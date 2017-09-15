
#ifndef MSGPACK_H
#define MSGPACK_H

#include "cocos2d.h"

class MsgPack
{
public:
    MsgPack();
    ~MsgPack();

    static std::string pack_xor(const std::string & msgBuff);
    static std::string unpack_xor(const std::string & msgBuff);
    static std::string pack_aes(const std::string & msgBuff);
    static std::string unpack2(const std::string & msgBuff);
    static std::string unpack_aes(const std::string & msgBuff, int * sss);

    static std::string urlEncodeForBase64(const std::string & base64);
    static std::string urlDecodeForUrlBase64(const std::string & urlbase64);
};

#endif 

