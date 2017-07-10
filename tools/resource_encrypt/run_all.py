
#coding:utf-8

#加密/解密 lua脚本和图片


#使用方法: 在cmd里执行命令 run_all.py -encode 或者 run_all.py -decode 

import os
import sys; sys.dont_write_bytecode = True #防止之后import其他自定义模块时在当前目录生成对应的pyc文件
import encrypt_lua
import encrypt_img
