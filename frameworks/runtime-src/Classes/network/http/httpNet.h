#ifndef __NEWHTTPNET_H__
#define __NEWHTTPNET_H__

#include "cocos2d.h"
#include "curl/curl.h"

//短连接

extern void g_heepNet_thread_callback();

class httpNet
{
    friend void g_heepNet_thread_callback();

    httpNet();
    ~httpNet();

    struct msgThreadData
    {
        msgThreadData() :_postData(""), _complete(false), _succeed(false), _isDiscard(false), _isGiveUp(false), _luaFunc(0), usePack(false), _connectTimeOut(0), _totalTimeOut(0), _id(0), _createTime(time(nullptr)), _responseCode(0), _performCode(CURLE_OK), selectPack2(false){};
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
        bool selectPack2;
        std::vector<char> _responseData;

        volatile bool _succeed;
        volatile bool _complete;
        volatile bool _isDiscard;
        volatile bool _isGiveUp;
        std::mutex _statusMutex;
    };

public:
static httpNet * getInstance();
static void destroyInstance();

    //请求
    void post(const char *urlString, const char *jsonString, int jsonSize, int luaCallbackFunc, int connectTime, int totalTime, bool useAsync, bool usePack, const char *headString = nullptr, const char *headSplitFlag = nullptr, const char *ssl_path = nullptr);

    void post2(const char *urlString, const char *jsonString, int jsonSize, int luaCallbackFunc, int connectTime, int totalTime, bool useAsync, bool usePack, const char *headString = nullptr, const char *headSplitFlag = nullptr, const char *ssl_path = nullptr);

    void get(const char *urlString, int luaCallbackFunc, int connectTime = 7, int totalTime = 7, const char * headString = nullptr, const char * headSplitFlag = nullptr, const char * ssl_path = nullptr);

    //舍弃当前所有请求
    void discardAllPost();

    void setFailedThing(bool var);

public:
    void updateLoop();

private:
    msgThreadData * _pop_received();
    void _process(msgThreadData * pMtd);
    bool _has(int id);

private:
    void _giveUpAllPost(msgThreadData * p);
    bool _inithttpNet();
    void _clearhttpNet();
    std::list<msgThreadData*> _msgQueue;
    std::mutex _msgQueueMutex;
    bool _failedThing;
};

#endif // __NEWHTTPNET_H__
