#!/usr/bin/env python
#coding:utf-8






#使用方法: 在cmd里执行命令 exec_config.py -add 或者 exec_config.py -remove 

import os
import shutil
import sys
sys.dont_write_bytecode = True #防止之后import 其他自定义模块(xxteaModule)时在当前目录生成对应的pyc文件
sys.path.append(os.path.abspath(os.path.dirname(__file__) + '/' + '..'))

import ScripUtils





path_jar              = "../../proj.android-studio/app/libs/libPluginProtocol.jar"
path_AppActivity_java = "../../proj.android-studio/app/src/org/cocos2dx/lua/AppActivity.java"
path_makefile         = "../../proj.android-studio/app/jni/Android.mk"
path_manifest         = "../../proj.android-studio/app/AndroidManifest.xml"



#Android
#   case1:拷贝jar库到 libs目录
def config_jar(bRemove):
    if bRemove:
        if os.path.isfile(path_jar):
            os.remove(path_jar)
    else:
        shutil.copyfile('./resource/libPluginProtocol.jar', path_jar)

#   case2:修改 AppActivity.java 
def config_AppActivity_java(bRemove):
    #1)文件开头 import 相关类
    str_heads = [
        'import com.anysdk.framework.PluginWrapper;'
    ]

    #2) 在 onCreate() 函数中注册微信添加如下内容
    str_onCreate = [
        'PluginWrapper.init(this);',
        'PluginWrapper.loadAllPlugins();'
    ]

    #3)在 onResume() 函数中注册微信添加如下内容
    str_onResume = [
        'PluginWrapper.onResume();'
    ]

    #4)在 onPause() 函数中注册微信添加如下内容
    str_onPause = [
        'PluginWrapper.onPause();'
    ]

    #5)在 onDestroy() 函数中注册微信添加如下内容
    str_onDestroy = [
        'PluginWrapper.onDestroy();'
    ]

    #6)在 onActivityResult() 函数中注册微信添加如下内容
    str_onActivityResult = [
        'PluginWrapper.onActivityResult(requestCode, resultCode, data);'
    ]

    #7)在 onNewIntent() 函数中注册微信添加如下内容
    str_onNewIntent = [
        'PluginWrapper.onNewIntent(intent);'
    ]

    #8)在 onStop() 函数中注册微信添加如下内容
    str_onStop = [
        'PluginWrapper.onStop();'
    ]

    #8)在 onRestart() 函数中注册微信添加如下内容
    str_onRestart = [
        'PluginWrapper.onRestart();'
    ]

    #9)在 onBackPressed() 函数中注册微信添加如下内容
    str_onBackPressed = [
        'PluginWrapper.onBackPressed();'
    ]

    #10)在 onConfigurationChanged() 函数中注册微信添加如下内容
    str_onConfigurationChanged = [
        'PluginWrapper.onConfigurationChanged(newConfig);'
    ]

    #11)在 onRestoreInstanceState() 函数中注册微信添加如下内容
    str_onRestoreInstanceState = [
        'PluginWrapper.onRestoreInstanceState(savedInstanceState);'
    ]

    #12)在 onSaveInstanceState() 函数中注册微信添加如下内容
    str_onSaveInstanceState = [
        'PluginWrapper.onSaveInstanceState(outState);'
    ]

    #13)在 onStart() 函数中注册微信添加如下内容
    str_onStart = [
        'PluginWrapper.onStart();'
    ]

    content = [ 
        [str_heads,                     '//SDK_TAG_IMPORT'],
        [str_onCreate,                  '//SDK_TAG_ONCREATE'],
        [str_onResume,                  '//SDK_TAG_ONRESUME'],
        [str_onPause,                   '//SDK_TAG_ONPAUSE'],
        [str_onDestroy,                 '//SDK_TAG_ONDESTROY'],
        [str_onActivityResult,          '//SDK_TAG_ONACTIVITYRESULT'],
        [str_onNewIntent,               '//SDK_TAG_ONNEWINTENT'],
        [str_onStop,                    '//SDK_TAG_ONSTOP'],
        [str_onRestart,                 '//SDK_TAG_ONRESTART'],
        [str_onBackPressed,             '//SDK_TAG_ONBACKPRESSED'],
        [str_onConfigurationChanged,    '//SDK_TAG_ONCONFIGURATION_CHANGED'],
        [str_onRestoreInstanceState,    '//SDK_TAG_ONRESTORE_INSTANCE_STATE'],
        [str_onSaveInstanceState,       '//SDK_TAG_ONSAVE_INSTANCE_STATE'],
        [str_onStart,                   '//SDK_TAG_ONSTART'],
    ]


    all_the_text = ScripUtils.readFile(path_AppActivity_java)

    all_the_text, isChanged = ScripUtils.modifyContent(all_the_text, content, bRemove)
    if isChanged:
        ScripUtils.writeFile(path_AppActivity_java, all_the_text)

#   case3:修改 Android.mk
def config_makefile(bRemove):
    #1)预编译宏
    str_cflag = [
        'LOCAL_CFLAGS += -DANYSDK_SUPPORT'
    ]

    #2) cpp 文件
    str_cpp = [
        'LOCAL_SRC_FILES +=../../../Classes/anysdk/anysdkbindings.cpp',
        'LOCAL_SRC_FILES +=../../../Classes/anysdk/anysdk_manual_bindings.cpp'
    ]

    #3) 引用静态库
    str_lib = [
        'LOCAL_WHOLE_STATIC_LIBRARIES += PluginProtocolStatic'
    ]

    #4) 导入库路径
    str_module = [
        '$(call import-add-path,$(HLB_DIR)/../)',
        '$(call import-module,protocols/android)'
    ]

    content = [ 
        [str_cflag,     '#SDK_TAG_CFLAGS'],
        [str_cpp,       '#SDK_TAG_SRC'],
        [str_lib,       '#SDK_TAG_LIB'],
        [str_module,    '#SDK_TAG_IMPORET_MODULE'],
    ]

    all_the_text = ScripUtils.readFile(path_makefile)

    all_the_text, isChanged = ScripUtils.modifyContent(all_the_text, content, bRemove)
    if isChanged:
        ScripUtils.writeFile(path_makefile, all_the_text)

#   case4:修改 AndroidManifest.xml 权限
def config_manifest(bRemove):
    str_permission = [
    '<!-- AnySDK start-->',
    '<uses-permission android:name="android.permission.RESTART_PACKAGES" />',
    '<uses-permission android:name="android.permission.KILL_BACKGROUND_PROCESSES" />'
    ]

    content = [ 
        [str_permission,     '<!--TAG_PERMISSION_FOR_SDK_END-->']
    ] 
    all_the_text = ScripUtils.readFile(path_manifest)

    all_the_text, isChanged = ScripUtils.modifyContent(all_the_text, content, bRemove)
    if isChanged:
        ScripUtils.writeFile(path_manifest, all_the_text)


#   case5:其他c++和lua代码部分由宏 ANYSDK_SUPPORT 来自动开关，这里暂时不做处理了


def do_configs(bRemove):
    config_jar(bRemove)
    config_AppActivity_java(bRemove)
    config_makefile(bRemove)
    config_manifest(bRemove)


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
