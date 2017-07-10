
#coding:utf-8

#资源图片的加密解密工具
#使用方法: 在cmd里执行命令 encrypt_img.py -encode 或者 encrypt_img.py -decode 


import sys, os, struct

s_BitmapPassword = 27

path_res = os.path.abspath("../../res/").replace("\\", "/")

png_encrypt_header = [
	0x89 ^ (s_BitmapPassword + 2),
	0x50 ^ (s_BitmapPassword + 2),
	0x4e ^ (s_BitmapPassword + 2),
	0x47 ^ (s_BitmapPassword + 2),
	0x0d ^ (s_BitmapPassword + 2),
	0x0a ^ (s_BitmapPassword + 2),
	0x1a ^ (s_BitmapPassword + 2),
	0x0a ^ (s_BitmapPassword + 2)
	]

jpg_encrypt_header = [
	0xFF ^ (s_BitmapPassword + 2),
	0xD8 ^ (s_BitmapPassword + 2)
	]


def isEncrypted(bytes, extName):
    ret = True
    if extName == '.png':
		for i in range(len(png_encrypt_header)):
			if png_encrypt_header[i] != bytes[i]:
				ret = False
				
    if extName == '.jpg':
		for i in range(len(jpg_encrypt_header)):
			if jpg_encrypt_header[i] != bytes[i]:
				ret = False	
	
    return ret 
	
def xorString(bytes):
    for i in range(0,12):
		bytes[i] = bytes[i]^(s_BitmapPassword + 2)
    for i in range(13, len(bytes)-1,2048):
		bytes[i] = bytes[i]^s_BitmapPassword		
    return bytes
	


def walk_dir(dir, mode):
    for filename in os.listdir(dir):
        if filename.startswith('~') or filename.startswith('.'):
            continue
			
        fullpath = os.path.join(dir, filename).replace("\\", "/")	#绝对路径
        relative_path = fullpath.replace(path_res + "/", "") 		#相对路径
		
        if os.path.isdir(fullpath):
            walk_dir(fullpath, mode)
			
        extName = os.path.splitext(filename)[1]
        if extName != '.png' and extName != '.jpg':
            continue
			

		

        file = open(fullpath, 'rb')
        str = file.read()
        file.close()
        
		
        bytes = bytearray(str)
		
        if mode == '-encode' and isEncrypted(bytes, extName):
			print( relative_path + " is encrypted !!")		
			continue
			
        if mode == '-decode' and not isEncrypted(bytes, extName):
			print( relative_path + " is decrypted !!")		
			continue

        print("  " + relative_path)
		
        str_encode = xorString(bytes)
		
        os.remove(fullpath)
        file_encode = open(fullpath, 'wb')
        file_encode.write(str_encode)        
        file_encode.close()	
        		



if len(sys.argv) != 2:
    print 'Usage: python', sys.argv[0], '-[encode | decode]'
    exit(1)
if sys.argv[1] not in ('-encode', '-decode'):
    print 'Usage: python', sys.argv[0], '-[encode | decode]'
    exit(1)

	
print("\n==== walk_dir, dir, mode = " + path_res + ", " + sys.argv[1] + " ====\n")
walk_dir(path_res, sys.argv[1])



