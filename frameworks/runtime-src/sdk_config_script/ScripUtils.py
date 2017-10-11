#!/usr/bin/env python
#coding:utf-8

import sys; sys.dont_write_bytecode = True #防止之后import 其他自定义模块(xxteaModule)时在当前目录生成对应的pyc文件




#脚本文件添加/删除字串

def readFile(filePath):
    file_object = open(filePath,'rb')
    all_the_text = file_object.read()
    file_object.close()
    return all_the_text

def writeFile(filePath,all_the_text):
    file_object = open(filePath,'wb')
    file_object.write(all_the_text)
    file_object.close()


# 往 allText 的pos位置插入字符串subStr,并且保持代码缩进
def insertStr(allText, subStr, pos):
    #先找出 pos位置相对于行首的距离(内容一般为 '\n\t'之类)
    tmp = pos
    for i in range(pos-1, 0, -1):
        tmp = i 
        if allText[i] == '\n':
            break;

    linePrefix = allText[tmp:pos]
    allText = allText[:pos] + subStr + linePrefix+ allText[pos:-1] 
    return allText 

# 从 pos 位置删除字符串subStr, 如果删除后所在位置为空白行则删除
def removeStr(allText, subStr, pos):

    #如果pos左边为空则到换行处为止
    pos_s = pos

    # for i in range(pos, 0, -1):
    #     if allText[i] != '\t' and allText[i] != ' ' and allText[i] != '\n':
    #         break  
    #     pos_s = i  

    #找出行尾位置
    pos_e = pos+len(subStr)
    for i in range(pos_e, len(allText)):
        if allText[i] != '\t' and allText[i] != ' ' and allText[i] != '\n':
            break
        pos_e = i+1 


    allText = allText[:pos_s] + allText[pos_e:]
    return allText 
