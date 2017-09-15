#include "HttpNet.h"
#include "../../encrypt/msgPack.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"


#if CC_TARGET_PLATFORM != CC_PLATFORM_WIN32
#include <unistd.h>
#endif // CC_TARGET_PLATFORM != CC_PLATFORM_WIN32


USING_NS_CC;

#define DEF_MIN_TIME	(3L)

static HttpNet *s_httpNet = NULL;
static int s_ITERATE_ID = 0;


static std::vector<std::string> s_splitString(const std::string & src, const std::string & separate_character)
{
	std::vector<std::string> strs;
	int separate_characterLen = separate_character.size();
	int lastPosition = 0, index = std::string::npos;
	while (std::string::npos != (index = src.find(separate_character, lastPosition)))
	{
		strs.push_back(src.substr(lastPosition, index - lastPosition));
		lastPosition = index + separate_characterLen;
	}
	std::string lastString = src.substr(lastPosition);
	if (!lastString.empty())
		strs.push_back(lastString);
	return strs;
}

static size_t download_callback(void *ptr, size_t size, size_t nmemb, void *stream)
{
    size_t sizes = size * nmemb;
    if (sizes > 0)
    {
        std::vector<char> *buffer = (std::vector<char>*)stream;
        buffer->insert(buffer->end(), (char*)ptr, (char*)ptr + sizes);
    }
    return sizes;
}





void httpThreadMain()
{
    while (true)
    {
        if (!s_httpNet)
        {
            break;
        }
        
        HttpNet::msgThreadData *pMtd = s_httpNet->getReqData();
        if (pMtd)
        {
            time_t currentTime = time(nullptr);
            long subTime = (long)(currentTime - pMtd->_createTime);
            if (subTime > 0L)
            {
                pMtd->_totalTimeOut -= subTime;
                if (pMtd->_totalTimeOut < DEF_MIN_TIME)
                    pMtd->_totalTimeOut = DEF_MIN_TIME;

                pMtd->_connectTimeOut -= subTime;
                if (pMtd->_connectTimeOut < DEF_MIN_TIME) 
                    pMtd->_connectTimeOut = DEF_MIN_TIME;
            }
            //socket send
            s_httpNet->doPostByCurl(pMtd); 
            
            //notify to user
            Director::getInstance()->getScheduler()->performFunctionInCocosThread([&, pMtd](){ s_httpNet->processResponse(pMtd);});
            
            //when error, discard all request
            if (!pMtd->_succeed && s_httpNet->isFailedThing())
            {
                s_httpNet->discardAllPost();
            }
        }
        
        else
        {
        #if CC_TARGET_PLATFORM == CC_PLATFORM_WIN32
            Sleep(50);
        #else
            usleep(50000);
        #endif
        }
    }
}


HttpNet* HttpNet::getInstance()
{
	if (!s_httpNet)
	{
		s_httpNet = new HttpNet();
		s_httpNet->inithttpNet();
	}
	return s_httpNet;
}


void HttpNet::destroyInstance()
{
	if (s_httpNet)
	{
		HttpNet * temp = s_httpNet;
		s_httpNet = nullptr;
		temp->clearhttpNet();
		delete temp;
	}
}


HttpNet::HttpNet():m_failedThing(true)
{
}


HttpNet::~HttpNet()
{
}


/*压缩并使用AES 加密*/
void HttpNet::post(const char * urlString, const char * jsonString, int jsonSize, int luaCallbackFunc, int connectTime, int totalTime, bool useAsync, bool usePack, const char * headString /*= nullptr*/, const char * headSplitFlag /*= nullptr*/, const char * ssl_path /*= nullptr*/)
{
    msgThreadData * pTd = new msgThreadData();
    pTd->_id = ++s_ITERATE_ID;
    pTd->_url = urlString;
    if (headString)
    {
        pTd->_head = headString;
        if (headSplitFlag)
            pTd->_headSplitFlag = headSplitFlag;
    }
    
    if (ssl_path)
    {
        pTd->_sslPath = ssl_path;
    }
    pTd->_luaFunc = luaCallbackFunc;
    pTd->_connectTimeOut = connectTime;
    pTd->_totalTimeOut = totalTime;
    pTd->usePack = usePack;
    pTd->_postData.append(jsonString, (std::string::size_type)jsonSize);
    if (useAsync)
    {
        m_queueMutex.lock();
        m_reqQueue.push_back(pTd);
        m_queueMutex.unlock();
    }
    else 
    {
        doPostByCurl(pTd);
        processResponse(pTd);
    }
}

void HttpNet::get(const char * urlString, int luaCallbackFunc, int connectTime /*= 7*/, int totalTime /*= 7*/, const char * headString /*= nullptr*/, const char * headSplitFlag /*= nullptr*/, const char * ssl_path /*= nullptr*/)
{
    bool isSucceed = false;
    std::vector<char> getDataBuffer;
    CURL * easy_handle = NULL;
    curl_slist * slist = nullptr;
    
    do{
        easy_handle = curl_easy_init();
        CC_BREAK_IF(!easy_handle);
        if (ssl_path && strcmp(ssl_path,""))
        {
            CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_SSL_VERIFYPEER, 1L));
            CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_SSL_VERIFYHOST, 2L));
            CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_CAINFO, ssl_path));
        }
        else 
        {
            CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_SSL_VERIFYPEER, 0L));
            CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_SSL_VERIFYHOST, 0L));
        }
        CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_NOSIGNAL, 1L));
        CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_ACCEPT_ENCODING, ""));
        CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_TIMEOUT, (long)(totalTime)));
        CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_CONNECTTIMEOUT, (long)(connectTime)));
        CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_RESUME_FROM, 0L));
        CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_PORT, 0L));
        
        std::string headStr = ((headString) ? (headString) : (""));
        std::string headSplitFlagStr = ((headSplitFlag) ? (headSplitFlag) : (""));
        if (!headStr.empty())
        {
            if (!headSplitFlagStr.empty())
            {
                std::vector<std::string> head_vector = s_splitString(headStr, headSplitFlagStr);
                for (std::vector<std::string>::iterator it = head_vector.begin(); it != head_vector.end(); it++)
                {
                    if (!(*it).empty())
                        slist = curl_slist_append(slist, (*it).c_str());
                }
            }
            else
            {
                slist = curl_slist_append(slist, headStr.c_str());
            }
        }
        
        if (slist)
        {
            CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_HTTPHEADER, slist));
        }
        CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_HEADER, 0L));
        CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_NOBODY, 0L));
        CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_URL, urlString));
        CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_WRITEFUNCTION, &download_callback));
        getDataBuffer.reserve(4096);
        getDataBuffer.clear();
        CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_WRITEDATA, &getDataBuffer));
        CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_NOPROGRESS, 1L));
        long responseCode = 0;
        if (CURLE_OK == curl_easy_perform(easy_handle))
            CC_BREAK_IF(CURLE_OK != curl_easy_getinfo(easy_handle, CURLINFO_RESPONSE_CODE, &(responseCode)));
        CC_BREAK_IF(responseCode != 200);
        isSucceed = true;
    } while (false);
    
    if (easy_handle)
        curl_easy_cleanup(easy_handle);
    if (slist)
        curl_slist_free_all(slist);

    std::string dataString = "";
    std::stringstream s;
    s.str("");
    for (unsigned int i = 0; i < getDataBuffer.size(); i++)
    {
        s << (getDataBuffer)[i];
    }
    
    dataString = s.str();
    auto engine = LuaEngine::getInstance();
    auto pStack = engine->getLuaStack();
    pStack->pushBoolean(isSucceed);
    pStack->pushString(dataString.c_str(), dataString.size());
    pStack->executeFunctionByHandler(luaCallbackFunc, 2);
    pStack->clean();
    cocos2d::ScriptEngineManager::getInstance()->getScriptEngine()->removeScriptHandler(luaCallbackFunc);
}

void HttpNet::discardAllPost()
{
	m_queueMutex.lock();
	for (auto it = m_reqQueue.begin(); it != m_reqQueue.end();it++)
	{
		(*it)->_statusMutex.lock();
		(*it)->_isDiscard = true;
		(*it)->_statusMutex.unlock();
	}
	m_queueMutex.unlock();
}

void HttpNet::setFailedThing(bool var)
{
    m_failedThing = var;
}

bool HttpNet::isFailedThing()
{
    return m_failedThing;
}

void HttpNet::doPostByCurl(msgThreadData *pMtd)
{

    bool isSucceed = false;
    CURL *easy_handle = NULL;
    curl_slist *slist = nullptr;
    std::string msg_data = "";
    
    do {
        easy_handle = curl_easy_init();
        CC_BREAK_IF(!easy_handle);
        if (!pMtd->_sslPath.empty())
        {
            CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_SSL_VERIFYPEER, 1L));
            CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_SSL_VERIFYHOST, 2L));
            CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_CAINFO, pMtd->_sslPath.c_str()));
        }
        else
        {
            CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_SSL_VERIFYPEER, 0L));
            CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_SSL_VERIFYHOST, 0L));
        }
        CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_NOSIGNAL, 1L));
        CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_ACCEPT_ENCODING, ""));
        CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_TIMEOUT, (long)(pMtd->_totalTimeOut)));
        CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_CONNECTTIMEOUT, (long)(pMtd->_connectTimeOut)));
        CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_RESUME_FROM, 0L));
        CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_POST, 1L));
        
        long post_size = 0L;
        if (pMtd->usePack)
        {
            msg_data = MsgPack::pack_aes(pMtd->_postData);
            post_size = (long)msg_data.size();
            CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_POSTFIELDS, msg_data.c_str()));
            CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_POSTFIELDSIZE, post_size));
        }
        else
        {
            post_size = (long)(pMtd->_postData.size());
            CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_POSTFIELDS, pMtd->_postData.c_str()));
            CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_POSTFIELDSIZE, post_size));
        }
        
        if (post_size > 1024)
        {
            slist = curl_slist_append(slist, "Expect:");
        }
        
        if (!pMtd->_head.empty())
        {
            if (!pMtd->_headSplitFlag.empty())
            {
                std::vector<std::string> head_vector = s_splitString(pMtd->_head, pMtd->_headSplitFlag);
                for (std::vector<std::string>::iterator it = head_vector.begin(); it != head_vector.end(); it++)
                {
                    if (!(*it).empty())
                        slist = curl_slist_append(slist, (*it).c_str());
                }
            }
            else
            {
                slist = curl_slist_append(slist, pMtd->_head.c_str());
            }	
        }
        
        if (slist)
        {
            CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_HTTPHEADER, slist));
        }
        CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_HEADER, 0L));
        CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_NOBODY, 0L));
        CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_URL, pMtd->_url.c_str()));
        CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_WRITEFUNCTION, &download_callback));
        pMtd->_responseData.reserve(16384);
        pMtd->_responseData.clear();
        CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_WRITEDATA, &(pMtd->_responseData)));
        CC_BREAK_IF(CURLE_OK != curl_easy_setopt(easy_handle, CURLOPT_NOPROGRESS, 1L));
        
        pMtd->_performCode = curl_easy_perform(easy_handle);
        if (pMtd->_performCode == CURLE_OK) 
        {
            CC_BREAK_IF(CURLE_OK != curl_easy_getinfo(easy_handle, CURLINFO_RESPONSE_CODE, &(pMtd->_responseCode)));
        }

        CC_BREAK_IF(pMtd->_responseCode != 200);
        isSucceed = true;
    } while (false);
    
    if (easy_handle)
        curl_easy_cleanup(easy_handle);
    if (slist)
        curl_slist_free_all(slist);

    
    pMtd->_statusMutex.lock();
    pMtd->_succeed = isSucceed;
    pMtd->_statusMutex.unlock();
}

void HttpNet::processResponse(msgThreadData *pMtd)
{
    if (!pMtd->_isDiscard)
    {
        std::string dataString = "";
        std::stringstream s;
        s.str("");
        for (unsigned int i = 0; i < pMtd->_responseData.size(); i++)
        {
            s << (pMtd->_responseData)[i];
        }
        dataString = s.str();

        if (pMtd->_succeed && pMtd->usePack)
        {
            int sss = 0;
            dataString = MsgPack::unpack_aes(dataString, &sss); 
        }
        auto pStack = LuaEngine::getInstance()->getLuaStack();        
        pStack->pushBoolean(pMtd->_succeed);
        pStack->pushString(dataString.c_str(), dataString.size());
        pStack->pushInt(pMtd->_performCode);
        pStack->pushLong(pMtd->_responseCode);
        pStack->executeFunctionByHandler(pMtd->_luaFunc, 4);
        pStack->clean();
    }
    cocos2d::ScriptEngineManager::getInstance()->getScriptEngine()->removeScriptHandler(pMtd->_luaFunc);

    delete pMtd;
}

HttpNet::msgThreadData *HttpNet::getReqData()
{
    HttpNet::msgThreadData *pMtd = nullptr;
    
    m_queueMutex.lock();
    if (m_reqQueue.size() > 0)
    {
        pMtd = m_reqQueue.front();
        m_reqQueue.pop_front();
        if (pMtd->_isDiscard)
        {
            delete pMtd;
            pMtd = nullptr;
        }
    }
    m_queueMutex.unlock();
    
    return pMtd;
}

bool HttpNet::inithttpNet() 
{
    bool Ret = false;
    
    do {
        CC_BREAK_IF(CURLE_OK != curl_global_init(CURL_GLOBAL_ALL)); 
        //curl_version_info_data * curlinfodata = curl_version_info(CURLVERSION_NOW);
        std::thread(&httpThreadMain).detach();
        Ret = true;
    } while (false);
    
    return Ret;
}


void HttpNet::clearhttpNet()
{
	curl_global_cleanup();
}

