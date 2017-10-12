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
import android.util.Log;
import android.view.KeyEvent;
import android.widget.Toast;
import com.hlb.sale.R;
import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import java.lang.reflect.Method;

//SDK_TAG_IMPORT  脚本自动添加代码时用来定位，不要删！！by hlb


public class AppActivity extends Cocos2dxActivity{
    private long exitTime = 0;
	
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
		
        //SDK_TAG_ONCREATE  脚本自动添加代码时用来定位，不要删！！by hlb
    }

    @Override
    protected void onResume() {
		
		//SDK_TAG_ONRESUME  脚本自动添加代码时用来定位，不要删！！by hlb
        super.onResume();
    }

    @Override
    protected void onPause() {
		
		//SDK_TAG_ONPAUSE  脚本自动添加代码时用来定位，不要删！！by hlb
        super.onPause();
    }

    @Override
    protected void onDestroy() {
		
		//SDK_TAG_ONDESTROY  脚本自动添加代码时用来定位，不要删！！by hlb
        super.onDestroy();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
	
		//SDK_TAG_ONACTIVITYRESULT  脚本自动添加代码时用来定位，不要删！！by hlb
        super.onActivityResult(requestCode, resultCode, data);
    }

    @Override
    protected void onNewIntent(Intent intent) {

		//SDK_TAG_ONNEWINTENT  脚本自动添加代码时用来定位，不要删！！by hlb
        super.onNewIntent(intent);
    }

    @Override
    protected void onStop() {
		
		//SDK_TAG_ONSTOP  脚本自动添加代码时用来定位，不要删！！by hlb
        super.onStop();
    }

    @Override
    protected void onRestart() {
		
		//SDK_TAG_ONRESTART  脚本自动添加代码时用来定位，不要删！！by hlb
        super.onRestart();
    }

    @Override
    public void onBackPressed() {
		
		//SDK_TAG_ONBACKPRESSED  脚本自动添加代码时用来定位，不要删！！by hlb
        super.onBackPressed();
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
		
		//SDK_TAG_ONCONFIGURATION_CHANGED  脚本自动添加代码时用来定位，不要删！！by hlb
        super.onConfigurationChanged(newConfig);
    }

    @Override
    protected void onRestoreInstanceState(Bundle savedInstanceState) {
		
		//SDK_TAG_ONRESTORE_INSTANCE_STATE  脚本自动添加代码时用来定位，不要删！！by hlb
        super.onRestoreInstanceState(savedInstanceState);
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
	
		//SDK_TAG_ONSAVE_INSTANCE_STATE  脚本自动添加代码时用来定位，不要删！！by hlb
        super.onSaveInstanceState(outState);
    }

    @Override
    protected void onStart() {
		
		//SDK_TAG_ONSTART  脚本自动添加代码时用来定位，不要删！！by hlb
        super.onStart();
    }
	public static void isFuncExist(String className, String funcName, int callback) {
        String isPresent = "false";
        Class<?> c = null;
        try {
            c = Class.forName(className);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        if (c != null) {
            for (Method method : c.getMethods()) {
                System.out.println(method.getName());
//                Log.d("hlb", "===="+method.getName());
                if (method.getName().equals(funcName)){
                    isPresent = "true";
                    break;
                }
            }
        }
        Cocos2dxLuaJavaBridge.callLuaFunctionWithString(callback, isPresent);
        Cocos2dxLuaJavaBridge.releaseLuaFunction(callback);
    }

	//SDK_TAG_NEW_FUNC


}
