
#include "GameUtil.h"


std::string GameUtil::getMD5Data(const char *data, int dataLen)
{
    const int MD5_DIGEST_LENGTH = 16;

    md5_state_t state;
    md5_byte_t digest[MD5_DIGEST_LENGTH];
    char hexOutput[(MD5_DIGEST_LENGTH << 1) + 1] = {0};

    md5_init(&state);
    md5_append(&state, (const md5_byte_t *)data, dataLen);
    md5_finish(&state, digest);

    for (int di = 0; di < 16; ++di)
        sprintf(hexOutput + di * 2, "%02x", digest[di]);
    
    return hexOutput;
}

std::string GameUtil::getMD5String(std::string &str)
{
    return GameUtil::getMD5Data(str.c_str(), str.size());
}
