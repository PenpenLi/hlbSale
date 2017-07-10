
#include "msgPack.h"
#include <zlib.h>
extern "C" {
#include "aes.h"
}

USING_NS_CC;



const unsigned long s_DeflatBuffer_Size = 32 * 1024;
static unsigned char s_DeflatBuffer[s_DeflatBuffer_Size] = { 0 };

/*异或算法*/
static char s_CryptKey[] = { 0x1d, 0x19, 0x02, 0x3d, 0x39, 0x22, 0x29, 0x28, 0x68, 0x0b, 0x1f, 0x7a, 0x6b, 0x6a, 0x5b, 0x2c };
static const int s_CryptKey_count = sizeof(s_CryptKey) / sizeof(char);
static const char s_CryptKey_mask = 0x51;
static bool s_CryptKeyFirstUes = true;

/*AES 算法*/
/*key 防止明文显示字串(因为可通过工具查看二进制文件里的字串)*/
#define  AES_KEY_SIZE 32
#define HEAD_SIZE sizeof(int)
static const unsigned char aes_key_mask[8] = {0x7a, 0x76, 0x79, 0x78, 0x74, 0x7a, 0x6a, 0x71};
static const unsigned char aes_key_mask2[8] = {0x77, 0x63, 0x60, 0x7c, 0x60, 0x67, 0x7c, 0x26};
static const unsigned char aes_key_mask3[16] = {0x2b, 0x21, 0x20, 0x2d, 0x20, 0x2b, 0x71, 0x7d, 0x6a, 0x72, 0x73, 0x7f, 0x71, 0x78, 0x7d, 0x6b};


//协定大端
static int convertToBigEndian(int v)
{
    unsigned short var = 0xddff;
    if ((*((unsigned char*)&var)) == 0xff)
    {
        int var = v;
        int len = sizeof(int);
        unsigned char * p = (unsigned char *)&var;
        for (int i = 0, j = len - 1; j > i; j--, i++)
        {
            unsigned char tv = p[j];
            p[j] = p[i];
            p[i] = tv;
        }
        return var;
    }
    return v;
}

static void msg_encrypt(unsigned char * buff, unsigned long length)
{
    if (s_CryptKeyFirstUes)
    {
        s_CryptKeyFirstUes = false;
        for (int i = 0; i < s_CryptKey_count; i++)
        {
            s_CryptKey[i] = (s_CryptKey[i]) ^ s_CryptKey_mask;
        }
    }
    
    int key_index = 0;
    for (unsigned long i = 0; i < length; i++)
    {
        (buff[i]) ^= s_CryptKey[key_index++];
        if (key_index == s_CryptKey_count)
        {
            key_index = 0;
        }
    }
}

static void msg_decrypt(unsigned char * buff, unsigned long length)
{
    if (s_CryptKeyFirstUes)
    {
        s_CryptKeyFirstUes = false;
        for (int i = 0; i < s_CryptKey_count; i++)
        {
            s_CryptKey[i] = (s_CryptKey[i]) ^ s_CryptKey_mask;
        }
    }
    
    int key_index = 0;
    for (unsigned long i = 0; i < length; i++)
    {
        (buff[i]) ^= s_CryptKey[key_index++];
        if (key_index == s_CryptKey_count)
        {
            key_index = 0;
        }
    }
}

static void aes_encode(const char *password, int passwordLength, unsigned char * in_buffer, int in_length, unsigned char ** out_buffer, int * out_length)
{
    aes_context aes_ctx;
    unsigned char iv[16] = {};
    unsigned char key[32] = {};
    memset(iv, 0, sizeof(iv));
    memset(key, 0, sizeof(key));
    memcpy(key, password, passwordLength);
    aes_setkey_enc(&aes_ctx, key, 256);

    int enc_length = in_length + 16 - in_length % 16;
    unsigned char * tempBuff = new unsigned char[enc_length];
    memcpy(tempBuff, in_buffer, in_length);
    if (enc_length > in_length)
    {
        memset(tempBuff + in_length, 0, enc_length - in_length);
    }

    *out_length = enc_length + HEAD_SIZE;
    *out_buffer = new unsigned char[*out_length];
    int originDataLength = convertToBigEndian((int)in_length);
    memcpy(*out_buffer, &originDataLength, HEAD_SIZE);

    aes_crypt_cbc(&aes_ctx, AES_ENCRYPT, enc_length, iv, tempBuff, (*out_buffer) + HEAD_SIZE);

    delete[] tempBuff;
}

static void aes_decode(const char * password, int passwordLength, unsigned char * in_buffer, int in_length, unsigned char ** out_buffer, int * out_length)
{
    aes_context aes_ctx;
    unsigned char iv[16] = {};
    unsigned char key[32] = {};
    memset(iv, 0, sizeof(iv));
    memset(key, 0, sizeof(key));
    memcpy(key, password, passwordLength);
    aes_setkey_dec(&aes_ctx, key, 256);

    int originDataLength = 0;
    memcpy(&originDataLength, in_buffer, HEAD_SIZE);
    *out_length = convertToBigEndian(originDataLength);
    *out_buffer = new unsigned char[in_length - HEAD_SIZE];

    aes_crypt_cbc(&aes_ctx, AES_DECRYPT, in_length - HEAD_SIZE, iv, in_buffer + HEAD_SIZE, *out_buffer);
}

/*消息压缩加密*/
std::string MsgPack::pack(const std::string & msgBuff)
{
    unsigned long origin_size = (unsigned long)(msgBuff.size());
    unsigned long need_size = compressBound(origin_size);
	
    unsigned char *buff = nullptr;
    unsigned long destLen = 0;

    if (need_size > s_DeflatBuffer_Size)
    {
        destLen = need_size;
        buff = new unsigned char[need_size];
    }
    else
    {
        destLen = s_DeflatBuffer_Size;
        buff = s_DeflatBuffer;
    }
	
    if (compress(buff, &destLen, (const unsigned char *)msgBuff.c_str(), origin_size) != Z_OK)
    {
        if (buff && buff != s_DeflatBuffer)
        {
            delete[] buff;
        }
        
        return "";
    }

    msg_encrypt(buff, destLen);

    char *encodedData = nullptr;
    cocos2d::base64Encode(buff, (unsigned int)destLen, &encodedData);

    std::string ret(encodedData);

    if (buff && buff != s_DeflatBuffer)
    {
        delete[] buff;
    }
    free(encodedData);

    return MsgPack::urlEncodeForBase64(ret);
}


std::string MsgPack::unpack(const std::string &msgBuff)
{
    std::string ret = "";

    if (msgBuff.size() == 0)
    {
        return ret;
    }

    unsigned char *decodedData = nullptr;
    int decodedDataLen = cocos2d::base64Decode((unsigned char*)msgBuff.c_str(), (unsigned int)(msgBuff.size()), &decodedData);

    if (decodedDataLen > 0)
    {
        msg_decrypt(decodedData, decodedDataLen);

        unsigned char *unpackedData = nullptr;
        ssize_t unpackedLen = cocos2d::ZipUtils::inflateMemoryWithHint(decodedData, (ssize_t)decodedDataLen, &unpackedData, ((decodedDataLen < 2000) ? (65536) : (131072)));

        if (unpackedLen > 0)
        {
            ret.append((const char *)unpackedData, (std::string::size_type)unpackedLen);
        }
    #if defined(COCOS2D_DEBUG) && COCOS2D_DEBUG > 0
        else
        {
            std::string originData(msgBuff.c_str(), msgBuff.size());
            originData.append("\0", 1);
            CCLOG("uncompress length zero : %s", originData.c_str());
        }
    #endif
    
        if (unpackedData)
        {
            free(unpackedData);
        }
    }
    
#if defined(COCOS2D_DEBUG) && COCOS2D_DEBUG > 0
    else
    {
        std::string originData(msgBuff.c_str(), msgBuff.size());
        originData.append("\0", 1);
        CCLOG("base64Decode length zero : %s", originData.c_str());
    }
#endif

    if (decodedData)
    {
        free(decodedData);
    }
    
    return ret;
}


/*使用AES 加密*/
std::string MsgPack::pack2(const std::string & msgBuff)
{
    char aes_key_buf[AES_KEY_SIZE] = { 0 };
    for (int i = 0; i < AES_KEY_SIZE; i++)
    {
        if (i < 8)
            aes_key_buf[i] = ((unsigned char)(aes_key_mask[i])) ^ 18;
        else if (i < 16)
            aes_key_buf[i] = ((unsigned char)(aes_key_mask2[i - 8])) ^ 21;
        else
            aes_key_buf[i] = ((unsigned char)(aes_key_mask3[i - 16])) ^ 25;
    }

    unsigned long origin_size = (unsigned long)(msgBuff.size());
    unsigned long need_size = compressBound(origin_size);

    unsigned char * buff = nullptr;
    unsigned long destLen = 0;

    if (need_size > s_DeflatBuffer_Size)
    {
        destLen = need_size;
        buff = new unsigned char[need_size];
    }
    else
    {
        destLen = s_DeflatBuffer_Size;
        buff = s_DeflatBuffer;
    }

    if (compress(buff, &destLen, (const unsigned char *)msgBuff.c_str(), origin_size) != Z_OK)
    {
        if (buff && buff != s_DeflatBuffer)
        {
            delete[] buff;
        }
        return "";
    }
    
    unsigned char * outBuffer = nullptr;
    int outLength = 0;
    aes_encode(aes_key_buf, AES_KEY_SIZE, buff, destLen, &outBuffer, &outLength);

    if (buff && buff != s_DeflatBuffer)
    {
        delete[] buff;
    }
    
    if (outBuffer == nullptr || outLength <= 0)
    {
        if (outBuffer)
        {
            delete[] outBuffer;
        }
        return "";
    }

    char * encodedData = nullptr;
    cocos2d::base64Encode(outBuffer, (unsigned int)outLength, &encodedData);

    if (outBuffer)
    {
        delete[] outBuffer;
    }
    
    std::string ret(encodedData);

    free(encodedData);

    return MsgPack::urlEncodeForBase64(ret);
}


std::string MsgPack::unpack2(const std::string & msgBuff)
{
    char aes_key_buf[AES_KEY_SIZE] = { 0 };
    for (int i = 0; i < AES_KEY_SIZE; i++)
    {
        if (i < 8)
            aes_key_buf[i] = ((unsigned char)(aes_key_mask[i])) ^ 18;
        else if (i < 16)
            aes_key_buf[i] = ((unsigned char)(aes_key_mask2[i - 8])) ^ 21;
        else
            aes_key_buf[i] = ((unsigned char)(aes_key_mask3[i - 16])) ^ 25;
    }
    std::string ret = "";

    if (msgBuff.size() == 0)
    {
        return ret;
    }
    
    unsigned char * decodedData = nullptr;
    int decodedDataLen = cocos2d::base64Decode((unsigned char*)msgBuff.c_str(), (unsigned int)(msgBuff.size()), &decodedData);

    if (decodedDataLen > 0)
    {
#if defined(COCOS2D_DEBUG) && COCOS2D_DEBUG > 0
        do {
            int originDataLength = 0;
            memcpy(&originDataLength, decodedData, HEAD_SIZE);
            originDataLength = convertToBigEndian(originDataLength);
            if (originDataLength <= 0 || originDataLength > decodedDataLen)
            {
                std::string originData(msgBuff.c_str(), msgBuff.size());
                originData.append("\0", 1);
                CCLOG("Maybe unpack msg error : %s", originData.c_str());
            }
        } while (false);
#endif
        unsigned char * outBuffer = nullptr;
        int outLength = 0;
        aes_decode(aes_key_buf, AES_KEY_SIZE, decodedData, decodedDataLen, &outBuffer, &outLength);

        if (decodedData)
        {
            free(decodedData);
        }
        
        if (outBuffer == nullptr || outLength <= 0)
        {
            if (outBuffer)
                delete[] outBuffer;
            std::string originData(msgBuff.c_str(), msgBuff.size());
            originData.append("\0", 1);
            CCLOG("decrypt error : %s", originData.c_str());
        }
        else
        {
            unsigned char* unpackedData = nullptr;
            ssize_t unpackedLen = cocos2d::ZipUtils::inflateMemoryWithHint(outBuffer, (ssize_t)outLength, &unpackedData, ((outLength < 2000) ? (65536) : (131072)));
            if (outBuffer)
            {
                delete[] outBuffer;
            }
            
            if (unpackedLen > 0)
            {
                ret.append((const char *)unpackedData, (std::string::size_type)unpackedLen);
            }
        #if defined(COCOS2D_DEBUG) && COCOS2D_DEBUG > 0
            else
            {
                std::string originData(msgBuff.c_str(), msgBuff.size());
                originData.append("\0", 1);
                CCLOG("uncompress length zero : %s", originData.c_str());
            }
        #endif
        
            if (unpackedData)
            {
                free(unpackedData);
            }
        }
    }
#if defined(COCOS2D_DEBUG) && COCOS2D_DEBUG > 0
    else
    {
        if (decodedData)
            free(decodedData);
        std::string originData(msgBuff.c_str(), msgBuff.size());
        originData.append("\0", 1);
        CCLOG("base64Decode length zero : %s", originData.c_str());
    }
#endif

    return ret;
}

std::string MsgPack::unpack2_new(const std::string & msgBuff, int * sss)
{
    char aes_key_buf[AES_KEY_SIZE] = { 0 };
    for (int i = 0; i < AES_KEY_SIZE; i++)
    {
        if (i < 8)
            aes_key_buf[i] = ((unsigned char)(aes_key_mask[i])) ^ 18;
        else if (i < 16)
            aes_key_buf[i] = ((unsigned char)(aes_key_mask2[i - 8])) ^ 21;
        else
            aes_key_buf[i] = ((unsigned char)(aes_key_mask3[i - 16])) ^ 25;
    }

    std::string ret = "";

    if (msgBuff.size() == 0)
    {
        *sss = 0;
        return ret;
    }
    
    unsigned char *decodedData = nullptr;
    int decodedDataLen = cocos2d::base64Decode((unsigned char*)msgBuff.c_str(), (unsigned int)(msgBuff.size()), &decodedData);

    if (decodedDataLen > 0)
    {
        do{
            int originDataLength = 0;
            memcpy(&originDataLength, decodedData, HEAD_SIZE);
            originDataLength = convertToBigEndian(originDataLength);
            if (originDataLength <= 0 || originDataLength > decodedDataLen - HEAD_SIZE)
            {
                //由于服务器包装错误，造成客户端内存越界崩溃
                *sss = -1;
                std::string originData(msgBuff.c_str(), msgBuff.size());
                originData.append("\0", 1);
                CCLOG("server pack error : %s", originData.c_str());
                return ret;
            }
        } while (false);

        unsigned char * outBuffer = nullptr;
        int outLength = 0;
        aes_decode(aes_key_buf, AES_KEY_SIZE, decodedData, decodedDataLen, &outBuffer, &outLength);

        if (decodedData)
        {
            free(decodedData);
        }
        
        if (outBuffer == nullptr || outLength <= 0)
        {
            if (outBuffer)
            {
                delete[] outBuffer;
            }
            *sss = 0;
            std::string originData(msgBuff.c_str(), msgBuff.size());
            originData.append("\0", 1);
            CCLOG("decrypt error : %s", originData.c_str());
        }
        else
        {
            unsigned char* unpackedData = nullptr;
            ssize_t unpackedLen = cocos2d::ZipUtils::inflateMemoryWithHint(outBuffer, (ssize_t)outLength, &unpackedData, ((outLength < 2000) ? (65536) : (131072)));
            if (outBuffer)
            {
                delete[] outBuffer;
            }
            
            if (unpackedLen > 0)
            {
                *sss = 1;
                ret.append((const char *)unpackedData, (std::string::size_type)unpackedLen);
            }
        #if defined(COCOS2D_DEBUG) && COCOS2D_DEBUG > 0
            else
            {
                *sss = 0;
                std::string originData(msgBuff.c_str(), msgBuff.size());
                originData.append("\0", 1);
                CCLOG("uncompress length zero : %s", originData.c_str());
            }
        #endif
            if (unpackedData)
            {
                free(unpackedData);
            }
        }
    }
#if defined(COCOS2D_DEBUG) && COCOS2D_DEBUG > 0
    else
    {
        if (decodedData)
        {
            free(decodedData);
        }
        *sss = 0;
        std::string originData(msgBuff.c_str(), msgBuff.size());
        originData.append("\0", 1);
        CCLOG("base64Decode length zero : %s", originData.c_str());
    }
#endif

    return ret;
}


std::string MsgPack::urlEncodeForBase64(const std::string & base64)
{
    std::string ret = "";
    ret.reserve(base64.size() + 64);
    ret.append(base64.c_str(), base64.size());

    std::string::size_type offset = ret.npos;

    offset = ret.find("+", 0);
    while (offset != ret.npos)
    {
        ret.replace(offset, 1, "%2B");
        offset = ret.find("+", offset);
    }

    offset = ret.find("/", 0);
    while (offset != ret.npos)
    {
        ret.replace(offset, 1, "%2F");
        offset = ret.find("/", offset);
    }

    offset = ret.rfind("=");
    while (offset != ret.npos)
    {
        ret.replace(offset, 1, "%3D");
        offset = ret.rfind("=", offset);
    }

    return ret;
}

std::string MsgPack::urlDecodeForUrlBase64(const std::string & urlbase64)
{
    std::string ret = "";
    ret.reserve(urlbase64.size() + 8);
    ret.append(urlbase64.c_str(), urlbase64.size());

    std::string::size_type offset = ret.npos;

    offset = ret.find("%2B", 0);
    while (offset != ret.npos)
    {
        ret.replace(offset, 3, "+");
        offset = ret.find("%2B", offset);
    }

    offset = ret.find("%2b", 0);
    while (offset != ret.npos)
    {
        ret.replace(offset, 3, "+");
        offset = ret.find("%2b", offset);
    }

    offset = ret.find("%2F", 0);
    while (offset != ret.npos)
    {
        ret.replace(offset, 3, "/");
        offset = ret.find("%2F", offset);
    }

    offset = ret.find("%2f", 0);
    while (offset != ret.npos)
    {
        ret.replace(offset, 3, "/");
        offset = ret.find("%2f", offset);
    }

    offset = ret.rfind("%3D");
    while (offset != ret.npos)
    {
        ret.replace(offset, 3, "=");
        offset = ret.rfind("%3D", offset);
    }

    offset = ret.rfind("%3d");
    while (offset != ret.npos)
    {
        ret.replace(offset, 3, "=");
        offset = ret.rfind("%3d", offset);
    }
    
    return ret;
}




