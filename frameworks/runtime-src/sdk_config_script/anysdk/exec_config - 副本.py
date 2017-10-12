#!/usr/bin/env python
#coding:utf-8


# 关闭AnySdk功能步骤如下：
# 1) C++： frameworks\runtime-src\proj.android-studio\app\jni\Android.mk 里面修改C++部分的开关,如OPEN_ANYSDK = 0 ;
# 2) 移除 proj.android-studio\app\libs\下对应的jar包，比如改名为*.bak ，确保不会被编译到apk中 ;
# 3) AppActivity.java 中移除 import 语句, 同时修改如下第三方插件开关,如private static final boolean ANYSDK_SUPPORT = false;
# 4) proj.android-studio.iml 移除相关权限
# 5) res/资源体积不大，可以忽略

#使用方法: 在cmd里执行命令 exec_config.py -add 或者 exec_config.py -remove 


import os
import sys; 
sys.dont_write_bytecode = True #防止之后import 其他自定义模块(xxteaModule)时在当前目录生成对应的pyc文件
sys.path.append(os.path.abspath(os.path.dirname(__file__) + '/' + '..'))

import ScripUtils




path_makefile     = "../../proj.android-studio/app/jni/Android.mk"
path_jar = "../../proj.android-studio/app/libs/libPluginProtocol.jar"
path_AppActivity_java = "../../proj.android-studio/app/src/org/cocos2dx/lua/AppActivity.java"





#Android部分:
def config_makefile(bRemove):
    all_the_text = ScripUtils.readFile(path_makefile)
    TAG = 'OPEN_ANYSDK = '
    pos = all_the_text.find(TAG)
    if pos == -1 and not bRemove:
        print('cannot open anysdk, pls merge manually first !!!')
    elif pos > 0:
        pp = pos + len(TAG)
        if bRemove and all_the_text[pp] == '1':
            all_the_text = all_the_text[:pp] + '0' + all_the_text[pp+1:]
            ScripUtils.writeFile(path_makefile, all_the_text)
        elif not bRemove and all_the_text[pp] == '0':
            all_the_text = all_the_text[:pp] + '1' + all_the_text[pp+1:]
            ScripUtils.writeFile(path_makefile, all_the_text)


def config_jar(bRemove):
    bakName = path_jar+'.bak'
    if bRemove:
        if os.path.isfile(path_jar):
            os.rename(path_jar, bakName)
    else:
        if os.path.isfile(bakName):
            os.rename(bakName, path_jar)


#   case3:修改 AppActivity.java 
def config_AppActivity_java(bRemove):
    name = 'import com.anysdk.framework.PluginWrapper;'
    all_the_text = ScripUtils.readFile(path_AppActivity_java)
    isChanged = False 
    pos = all_the_text.find(name)
    if pos == -1 and not bRemove:
        print('cannot open anysdk, pls merge manually first !!!')   
    elif pos > 0:
        if bRemove:
            if all_the_text[pos-1] != '/':
                all_the_text = all_the_text[:pos] + '//' + all_the_text[pos:]
                isChanged = True 
        else:
            if all_the_text[pos-1] == '/':
                all_the_text = all_the_text[:pos-2] + all_the_text[pos:]
                isChanged = True 


    flag = False 
    tag1 = 'private static final boolean ANYSDK_SUPPORT = true;'
    tag2 = 'private static final boolean ANYSDK_SUPPORT = false;'
    if bRemove:
        all_the_text, flag = ScripUtils.replaceStr(all_the_text, tag1, tag2) 
        print('===flag1', flag)
    else:
        all_the_text, flag = ScripUtils.replaceStr(all_the_text, tag2, tag1) 
        print('===flag', flag)

    if flag:
        isChanged = True

    if isChanged:
        ScripUtils.writeFile(path_AppActivity_java, all_the_text)




def do_configs(bRemove):
    config_makefile(bRemove)
    config_jar(bRemove)
    config_AppActivity_java(bRemove)




def run(argv):	
    if len(argv) != 2:
        print 'Usage: python', argv[0], '-[add | remove]'
        exit(1)
    if argv[1] not in ('-add', '-remove'):
        print 'Usage: python', argv[0], '-[add | remove]'
        exit(1)	

    if argv[1] == '-add':
        print("@@@ start to merge ...")
        do_configs(False)
        print("### finish merge success ...")	

    elif argv[1] == '-remove':
        print("~~~ start remove ...")
        do_configs(True)


run(sys.argv)
