#ifndef __NEWHTTPNET_H__
#define __NEWHTTPNET_H__

#include "cocos2d.h"
#include "curl/curl.h"

//∂Ã¡¨Ω”
class HttpNet
{
public:
    HttpNet();
    ~HttpNet();

    struct msgThreadData
    {
        msgThreadData() :_postData(""), _succeed(false), _isDiscard(false),  _luaFunc(0), usePack(false), _connectTimeOut(0), _totalTimeOut(0),  _createTime(time(nullptr)), _responseCode(0), _performCode(CURLE_OK){};
        ~msgThreadData(){};
        std::string _url;
        std::string _head;
        std::string _headSplitFlag;
        std::string _sslPath;
        int _luaFunc;
        int _connectTimeOut; 
        int _totalTimeOut; 
        int _id;
        time_t _createTime;
        long _responseCode;
        CURLcode _performCode;
        std::string _postData;
        bool usePack;
        std::vector<char> _responseData;

        volatile bool _succeed;
        volatile bool _isDiscard;
        std::mutex _statusMutex;
    };


    static HttpNet *getInstance();
    static void destroyInstance();

    void post(const char *urlString, const char *jsonString, int jsonSize, int luaCallbackFunc, int connectTime, int totalTime, bool useAsync, bool usePack, const char *headString = nullptr, const char *headSplitFlag = nullptr, const char *ssl_path = nullptr);

    void get(const char *urlString, int luaCallbackFunc, int connectTime = 7, int totalTime = 7, const char * headString = nullptr, const char * headSplitFlag = nullptr, const char * ssl_path = nullptr);

    
    void discardAllPost();
    
    //when fail, then discard all request
    void setFailedThing(bool var);
    bool isFailedThing();
    
    void doPostByCurl(msgThreadData *pMtd);
    
    void processResponse(msgThreadData * pMtd);

    HttpNet::msgThreadData *getReqData();
        

private:
    bool inithttpNet();
    void clearhttpNet();
    std::list<msgThreadData*> m_reqQueue;
    std::mutex m_queueMutex;
    bool m_failedThing;
};

#endif // __NEWHTTPNET_H__
