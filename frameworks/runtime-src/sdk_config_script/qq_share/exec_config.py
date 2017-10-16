#!/usr/bin/env python
#coding:utf-8






#使用方法: 在cmd里执行命令 exec_config.py -add 或者 exec_config.py -remove 

import os
import shutil
import sys
sys.dont_write_bytecode = True #防止之后import 其他自定义模块(xxteaModule)时在当前目录生成对应的pyc文件
sys.path.append(os.path.abspath(os.path.dirname(__file__) + '/' + '..'))

import ScripUtils




name_jar              = "open_sdk_r5886_lite.jar"
path_jar              = "../../proj.android-studio/app/libs/"
path_AppActivity_java = "../../proj.android-studio/app/src/org/cocos2dx/lua/AppActivity.java"
path_manifest         = "../../proj.android-studio/app/AndroidManifest.xml"

APP_ID_QQ = '1106382333'

#Android
#   case1:拷贝jar库到 libs目录
def config_jar(bRemove):
    if bRemove:
        if os.path.isfile(path_jar+name_jar):
            os.remove(path_jar+name_jar)
    else:
        shutil.copyfile('./resource/'+name_jar, path_jar+name_jar)

#   case2:修改 AppActivity.java 
def config_AppActivity_java(bRemove):
    #1)文件开头 import 相关类
    str_heads = [
        'import com.tencent.connect.common.Constants;',
        'import com.tencent.connect.share.QQShare;',
        'import com.tencent.tauth.IUiListener;',
        'import com.tencent.tauth.Tencent;',
        'import com.tencent.tauth.UiError;'
    ]

    #2) 在 AppActivity 类中定义成员变量, 注意appid根据您的情况来修改
    str_var = [
        'private static Tencent mTencent = null;',
        'private static String APP_ID_QQ = "1106382333";'
    ]

    #3) 在 onCreate() 函数中注册微信添加如下内容
    str_onCreate = [
        'mTencent = Tencent.createInstance(APP_ID_QQ, this.getApplicationContext());'
    ]

    #4) 在 AppActivity 类中添加分享函数
    str_func1 = [
        '/** 分享回调实现类*/\n' \
        '\tprivate static IUiListener qqShareListener = new IUiListener() {\n' \
            '\t\t@Override\n' \
            '\t\tpublic void onError(UiError e) {\n' \
                '\t\t\tLog.d("hlb", "分享异常"+e.errorMessage + " :  " +e.errorDetail);\n' \
                '\t\t\tToast.makeText(mActivity, "分享异常", Toast.LENGTH_SHORT).show();\n' \
            '\t\t}\n' \
            '\t\t@Override\n' \
            '\t\tpublic void onComplete(Object response) {\n' \
                '\t\t\tLog.d("space", "分享成功" + response.toString());\n' \
                '\t\t\tToast.makeText(mActivity, "分享成功", Toast.LENGTH_SHORT).show();\n' \
            '\t\t}\n' \
            '\t\t@Override\n' \
            '\t\tpublic void onCancel() {\n' \
                '\t\t\tLog.d("space", "取消了分享");\n' \
            '\t\t}\n' \
        '\t};\n'        
    ]

    str_func2 = [
        '/**function:shareAppToQQ\n' \
        '\t * 分享应用到QQ空间\n' \
        '\t * @param title 分享的标题(必填)\n' \
        '\t * @param msg 分享的摘要,最长40个字符\n' \
        '\t * @param imgUrl 分享图片的URL或者本地路径\n' \
        '\t * @param backName 手Q客户端顶部，替换“返回”按钮文字，如果为空，用返回代替\n' \
        '\t */\n' \
        '\tpublic static void shareAppToQQ(String title,String msg, String imgUrl, String backName)\n' \
        '\t{\n' \
            '\t\tif(mTencent == null){\n' \
                '\t\t\treturn;\n' \
            '\t\t}\n' \

            '\t\tfinal Bundle params = new Bundle();\n' \
            '\t\t//分享的类型(必填)\n' \
            '\t\tparams.putInt(QQShare.SHARE_TO_QQ_KEY_TYPE, QQShare.SHARE_TO_QQ_TYPE_APP);\n' \
            '\t\t//分享的标题(必填)\n' \
            '\t\tparams.putString(QQShare.SHARE_TO_QQ_TITLE, title);\n' \
            '\t\t//分享的摘要,最长40个字符\n' \
            '\t\tparams.putString(QQShare.SHARE_TO_QQ_SUMMARY, msg);\n' \

            '\t\tif(! "".equals(imgUrl)){\n' \
                '\t\t\t//分享图片的URL或者本地路径\n' \
                '\t\t\tparams.putString(QQShare.SHARE_TO_QQ_IMAGE_URL, imgUrl);\n' \
            '\t\t}\n' \
            '\t\t//手Q客户端顶部，替换“返回”按钮文字，如果为空，用返回代替\n' \
            '\t\tif (null != backName && (! "".equals(backName))) {\n' \
                '\t\t\tparams.putString(QQShare.SHARE_TO_QQ_APP_NAME, backName);\n' \
            '\t\t}\n' \

            '\t\t//分享额外选项\n' \
            '\t\tparams.putInt(QQShare.SHARE_TO_QQ_EXT_INT, QQShare.SHARE_TO_QQ_FLAG_QZONE_AUTO_OPEN);\n' \
            '\t\tmTencent.shareToQQ(mActivity, params, qqShareListener);\n' \
        '\t}\n'
    ]

    #5)在 onActivityResult() 函数中注册微信添加如下内容
    str_onActivityResult = [
        'if (requestCode == Constants.REQUEST_QQ_SHARE || requestCode == Constants.REQUEST_QZONE_SHARE) {\n' \
        '\t\t\tTencent.onActivityResultData(requestCode, resultCode, data, qqShareListener);\n' \
        '\t\t}'
    ]


    content = [ 
        [str_heads,             '//SDK_TAG_IMPORT'],
        [str_var,               '//SDK_TAG_VAR'],
        [str_onCreate,          '//SDK_TAG_ONCREATE'],
        [str_func1,             '//SDK_TAG_NEW_FUNC'],
        [str_func2,             '//SDK_TAG_NEW_FUNC'],
        [str_onActivityResult,  '//SDK_TAG_ONACTIVITYRESULT'],
    ]


    all_the_text = ScripUtils.readFile(path_AppActivity_java)
    all_the_text, isChanged = ScripUtils.modifyContent(all_the_text, content, bRemove)
    if isChanged:
        ScripUtils.writeFile(path_AppActivity_java, all_the_text)


#   case4:修改 AndroidManifest.xml 权限
def config_manifest(bRemove):
    all_the_text = ScripUtils.readFile(path_manifest)

    #因为权限为通用,已包含，所以此处不再额外添加
    # str_permission = [
    # '<!--for QQ start-->',
    # '<uses-permission android:name="android.permission.INTERNET" />',
    # '<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />',
    # '<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />'
    # ]

    tmpStr ='<!--for QQ Start-->\n'\
            'preFix' + '<activity\n'\
            'preFix' + '\tandroid:name="com.tencent.tauth.AuthActivity"\n'\
            'preFix' + '\tandroid:launchMode="singleTask"\n'\
            'preFix' + '\tandroid:noHistory="true" >\n'\
            'preFix' + '\t<intent-filter>\n'\
            'preFix' + '\t\t<action android:name="android.intent.action.VIEW" />\n'\
            'preFix' + '\t\t<category android:name="android.intent.category.DEFAULT" />\n'\
            'preFix' + '\t\t<category android:name="android.intent.category.BROWSABLE" />\n'\
            'preFix' + '\t\t<data android:scheme="tencentXXXXXX" />\n'\
            'preFix' + '\t</intent-filter>\n'\
            'preFix' + '</activity>\n'\
            'preFix' + '<activity\n'\
            'preFix' + '\tandroid:name="com.tencent.connect.common.AssistActivity"\n'\
            'preFix' + '\tandroid:configChanges="orientation|keyboardHidden|screenSize"\n'\
            'preFix' + '\tandroid:theme="@android:style/Theme.Translucent.NoTitleBar" />'
    # 自动替换APP_ID和缩进
    tmpStr = tmpStr.replace('XXXXXX', APP_ID_QQ)
    tmpStr = tmpStr.replace('preFix', ScripUtils.getLinePreFix(all_the_text, '<!--TAG_APP_FOR_SDK_END-->'))
    str_in_application = [
        tmpStr
    ]

    content = [ 
        # [str_permission,     '<!--TAG_PERMISSION_FOR_SDK_END-->']
        [str_in_application, '<!--TAG_APP_FOR_SDK_END-->']
    ] 

    all_the_text, isChanged = ScripUtils.modifyContent(all_the_text, content, bRemove)
    if isChanged:
        ScripUtils.writeFile(path_manifest, all_the_text)


def do_configs(bRemove):
    config_jar(bRemove)
    config_AppActivity_java(bRemove)
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
