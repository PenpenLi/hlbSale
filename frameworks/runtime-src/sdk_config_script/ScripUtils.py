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
    allText = allText[:pos] + subStr + linePrefix+ allText[pos:] 
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


# 针对指定标签位置修改对应的文本(增加或删除):
# allText: 原文本内容
# bRemove：是否移除指定内容
# content: 所有要修改的部分, 每部分有个对应的定位标签,格式参入如下:
#
# str_heads = [
#     'import com.anysdk.framework.PluginWrapper;'
# ]
# content = [ 
#     [str_heads,                     '//SDK_TAG_IMPORT'],
# 其中 '//SDK_TAG_IMPORT' 为 str_heads部分对应的标签定位标志
def modifyContent(allText, content, bRemove):
    isChanged = False 
    for item in content:
        for v in item[0]:
            pos = allText.find(v)
            if pos == -1 and not bRemove: 
                tmp = allText.find(item[1])
                assert(tmp > 0)
                allText = insertStr(allText, v, tmp)
                isChanged = True 

            elif pos > 0 and bRemove:
                allText = removeStr(allText, v, pos)
                isChanged = True 
    return allText, isChanged


def replaceStr(allText, orgSub, newSub):
    isChanged = False 
    pos = allText.find(orgSub)
    if pos > 0:
        allText = allText[:pos] + newSub + allText[pos+len(orgSub):]
        isChanged = True


    return allText, isChanged

    