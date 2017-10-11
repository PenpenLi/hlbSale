/****************************************************************************
Copyright (c) 2008-2010 Ricardo Quesada
Copyright (c) 2010-2016 cocos2d-x.org
Copyright (c) 2013-2017 Chukong Technologies Inc.
 
http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
package org.cocos2dx.lua;

import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.view.KeyEvent;
import android.widget.Toast;

import com.hlb.sale.R;

import org.cocos2dx.lib.Cocos2dxActivity;


import com.anysdk.framework.PluginWrapper;

//SDK_TAG_IMPORT  脚本自动添加代码时用来定位，不要删！！by hlb


//移除第三方功能模块方法：
// 1) C++： frameworks\runtime-src\proj.android-studio\app\jni\Android.mk 里面修改C++部分的开关,如OPEN_ANYSDK = 0 ;
// 2) 移除 proj.android-studio\app\libs\下对应的jar包，比如改名为*.bak ，确保不会被编译到apk中 ;
// 3) AppActivity.java 中移除 import 语句, 同时修改如下第三方插件开关,如private static final boolean ANYSDK_SUPPORT = false;
// 4) proj.android-studio.iml 移除相关权限


public class AppActivity extends Cocos2dxActivity{
    private long exitTime = 0;

    //第三方插件开关
    private static final boolean ANYSDK_SUPPORT = true; //anysdk
    //SDK_TAG_VAR  脚本自动添加代码时用来定位，不要删！！by hlb
	
    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK){
            exit();
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }

    //exit game when keydown. --by hlb
    private void exit() {
        if ((System.currentTimeMillis() - exitTime) > 2000) {
            Toast.makeText(getApplicationContext(), R.string.exit_when_touch_again,
                    Toast.LENGTH_SHORT).show();
            exitTime = System.currentTimeMillis();
        } else {
            finish();
            System.exit(0);
        }
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (ANYSDK_SUPPORT) {
            PluginWrapper.init(this);
            PluginWrapper.loadAllPlugins();
        }
        //SDK_TAG_ONCREATE  脚本自动添加代码时用来定位，不要删！！by hlb
    }

    @Override
    protected void onResume() {
        if (ANYSDK_SUPPORT) {
            PluginWrapper.onResume();
        }
        super.onResume();
    }

    @Override
    protected void onPause() {
        if (ANYSDK_SUPPORT) {
            PluginWrapper.onPause();
        }
        super.onPause();
    }

    @Override
    protected void onDestroy() {
        if (ANYSDK_SUPPORT) {
            PluginWrapper.onDestroy();
        }
        super.onDestroy();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (ANYSDK_SUPPORT) {
            PluginWrapper.onActivityResult(requestCode, resultCode, data);
        }
        super.onActivityResult(requestCode, resultCode, data);
    }

    @Override
    protected void onNewIntent(Intent intent) {
        if (ANYSDK_SUPPORT) {
            PluginWrapper.onNewIntent(intent);
        }
        super.onNewIntent(intent);
    }

    @Override
    protected void onStop() {
        if (ANYSDK_SUPPORT) {
            PluginWrapper.onStop();
        }
        super.onStop();
    }

    @Override
    protected void onRestart() {
        if (ANYSDK_SUPPORT) {
            PluginWrapper.onRestart();
        }
        super.onRestart();
    }

    @Override
    public void onBackPressed() {
        if (ANYSDK_SUPPORT) {
            PluginWrapper.onBackPressed();
        }
        super.onBackPressed();
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        if (ANYSDK_SUPPORT) {
            PluginWrapper.onConfigurationChanged(newConfig);
        }
        super.onConfigurationChanged(newConfig);
    }

    @Override
    protected void onRestoreInstanceState(Bundle savedInstanceState) {
        if (ANYSDK_SUPPORT) {
            PluginWrapper.onRestoreInstanceState(savedInstanceState);
        }
        super.onRestoreInstanceState(savedInstanceState);
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        if (ANYSDK_SUPPORT) {
            PluginWrapper.onSaveInstanceState(outState);
        }
        super.onSaveInstanceState(outState);
    }

    @Override
    protected void onStart() {
        if (ANYSDK_SUPPORT) {
            PluginWrapper.onStart();
        }
        super.onStart();
    }
}
