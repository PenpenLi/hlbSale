
#coding:utf-8

#自动加密目录下的lua,
#自动修改AppDelegate.cpp中setXXTEAKeyAndSign()相应的密码与签名;
#如果关闭了自动修改cpp,则需要手动修改


#使用方法: 在cmd里执行命令 encrypt_lua.py -encode 或者 encrypt_lua.py -decode 

import os
import sys; sys.dont_write_bytecode = True #防止之后import 其他自定义模块(xxteaModule)时在当前目录生成对应的pyc文件
import xxteaModule #这是对xxtea.cpp算法的python封装





#配置路径和XXTEA算法的key、sign
srcLuaPath = "D:/hlb/hlb_sale/src/"
cppFilePath = "D:/hlb/hlb_sale/frameworks/runtime-src/Classes/AppDelegate.cpp"

xxtea_key = "hlbEncrypt"
xxtea_sign = "hlbsign"



def ReadFile(filePath):
    file_object = open(filePath,'rb')
    all_the_text = file_object.read()
    file_object.close()
    return all_the_text

def WriteFile(filePath,all_the_text):
    file_object = open(filePath,'wb')
    file_object.write(all_the_text)
    file_object.close()
	
def BakFile(filePath,all_the_text):
    file_bak = filePath[:len(filePath)-3] + 'bak'
    WriteFile(file_bak,all_the_text)

def ListLua(path):
    fileList = []
    for root,dirs,files in os.walk(path):
        for eachfiles in files:
            if eachfiles[-4:] == '.lua' :
                fileList.append(root + '/' + eachfiles)
    return fileList

def EncodeWithXxteaModule(filePath,key,signment):
    all_the_text = ReadFile(filePath)
    if all_the_text[:len(signment)] == signment :
        return

    #bak lua
    #BakFile(filePath,all_the_text)
	
    encrypt = xxteaModule.encrypt(all_the_text,key)
    str = signment + encrypt
    WriteFile(filePath,str)

def DecodeWithXxteaModule(filePath,key,signment):
    all_the_text = ReadFile(filePath)
    if all_the_text[:len(signment)] != signment :
        return

    str = xxteaModule.decrypt(all_the_text[len(signment):], key)
    WriteFile(filePath, str)
	
def EncodeLua(srcPath, key,signment):
    fileList = ListLua(srcPath)
    for file in fileList:
        EncodeWithXxteaModule(file, key, signment)
	

def DecodeLua(srcPath, key,signment):
    fileList = ListLua(srcPath)
    for file in fileList:
        DecodeWithXxteaModule(file, key, signment)
	
def FixCpp(cppPath, key, signment):	
    all_the_text = ReadFile(cppPath)
    #bak cpp
    BakFile(cppPath,all_the_text)
	
    pos = all_the_text.find('stack->setXXTEAKeyAndSign')
    left = all_the_text.find('(',pos)
    right = all_the_text.find(';',pos)
    word = str.format('("%s", strlen("%s"), "%s", strlen("%s"))' % (key,key,signment,signment))
    all_the_text = all_the_text[:left] + word + all_the_text[right:-1]
    WriteFile(cppPath,all_the_text)
	
	
	
def run(argv):	
	if len(argv) != 2:
		print 'Usage: python', argv[0], '-[encode | decode]'
		exit(1)
	if argv[1] not in ('-encode', '-decode'):
		print 'Usage: python', argv[0], '-[encode | decode]'
		exit(1)	

	if argv[1] == '-encode':
		print("@@@ start encode lua ...")
		EncodeLua(srcLuaPath, xxtea_key, xxtea_sign)
		#FixCpp(cppFilePath, xxtea_key, xxtea_sign)
		print("### finish encode lua success ...")	
		
	elif argv[1] == '-decode':
		print("~~~ start decode lua ...")
		DecodeLua(srcLuaPath, xxtea_key, xxtea_sign) 


		
run(sys.argv)

	