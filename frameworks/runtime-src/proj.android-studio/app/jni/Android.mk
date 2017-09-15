LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := cocos2dlua_shared

LOCAL_MODULE_FILENAME := libcocos2dlua

LOCAL_SRC_FILES := \
../../../Classes/AppDelegate.cpp \
../../../Classes/network/tcp/SimpleSocket/SimpleSocket.cpp \
../../../Classes/network/tcp/NetManager.cpp \
../../../Classes/network/tcp/NetConnectionImpl.cpp \
../../../Classes/network/tcp/NetLua.cpp \
../../../Classes/network/http/HttpNet.cpp \
../../../Classes/forLua/forLua.cpp \
../../../Classes/encrypt/aes.c \
../../../Classes/encrypt/msgPack.cpp \
../../../Classes/cjson/fpconv.c \
../../../Classes/cjson/lua_cjson.c \
../../../Classes/cjson/strbuf.c \
../../../Classes/common/GameUtil.cpp \
hellolua/main.cpp


LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../Classes

# _COCOS_HEADER_ANDROID_BEGIN
# _COCOS_HEADER_ANDROID_END

LOCAL_STATIC_LIBRARIES := cocos2d_lua_static

LOCAL_STATIC_LIBRARIES += cocos_curl_static

# _COCOS_LIB_ANDROID_BEGIN
# _COCOS_LIB_ANDROID_END

include $(BUILD_SHARED_LIBRARY)

$(call import-module,scripting/lua-bindings/proj.android)

$(call import-module,./curl/prebuilt/Android)

# _COCOS_LIB_IMPORT_ANDROID_BEGIN
# _COCOS_LIB_IMPORT_ANDROID_END
