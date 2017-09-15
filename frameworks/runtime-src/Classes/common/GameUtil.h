
#ifndef GAMEUTIL_H
#define GAMEUTIL_H 

#include "cocos2d.h"
#include "encrypt/md5.h"

class GameUtil 
{
public:
    GameUtil();
    ~GameUtil();
    
    static std::string getMD5Data(const char *data, int dataLen);
    static std::string getMD5String(std::string &str);
};


#endif 

