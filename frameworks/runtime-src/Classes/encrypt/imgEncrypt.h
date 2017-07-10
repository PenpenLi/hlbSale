
#ifndef IMGENCRYPT_H
#define IMGENCRYPT_H 

#include <string.h>

static const unsigned char s_BitmapPassword = 27;
static const unsigned char PNG_SIGNATURE_DECRYPT[] = {
	0x89 ^ (s_BitmapPassword + 2)
	, 0x50 ^ (s_BitmapPassword + 2)
	, 0x4e ^ (s_BitmapPassword + 2)
	, 0x47 ^ (s_BitmapPassword + 2)
	, 0x0d ^ (s_BitmapPassword + 2)
	, 0x0a ^ (s_BitmapPassword + 2)
	, 0x1a ^ (s_BitmapPassword + 2)
	, 0x0a ^ (s_BitmapPassword + 2)
	};

static const unsigned char JPG_SOI_DECRYPT[] = {
	0xFF ^ (s_BitmapPassword + 2)
	, 0xD8 ^ (s_BitmapPassword + 2)
};


inline bool isPngEncrypted(const unsigned char *data)
{
    return memcmp(PNG_SIGNATURE_DECRYPT, data, sizeof(PNG_SIGNATURE_DECRYPT)) == 0;
}

inline bool isJpgEncrypted(const unsigned char *data)
{
    return memcmp(JPG_SOI_DECRYPT, data, sizeof(JPG_SOI_DECRYPT)) == 0;
}


//encrypt and decrypt is same function
inline void decrypt(char *imgType, unsigned char *data, int len)
{
    if ( (strcmp(imgType, "png") == 0 && isPngEncrypted(data))||(strcmp(imgType, "jpg") == 0 && isJpgEncrypted(data)) )
    {
        for (int _count = 0; _count < 13; _count++)
        {
            data[_count] ^= (s_BitmapPassword + 2);
        }
        
        for (int _count = 13; _count < len; _count += 2048)
        {
            data[_count] ^= s_BitmapPassword;
        }    
    }
}



#endif 
