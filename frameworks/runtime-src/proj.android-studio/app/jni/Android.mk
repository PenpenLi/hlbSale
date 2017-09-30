LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

#备份一下当前路径,因为当加载其他模块的Android.mk时可能会覆盖 LOCAL_PATH 这个变量,导致后续路径出错
HLB_DIR := $(LOCAL_PATH)

#AnySDK总开关
OPEN_ANYSDK = 1


#预编译宏
ifeq ($(OPEN_ANYSDK),1)
LOCAL_CFLAGS += -DANYSDK_SUPPORT
endif


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


ifeq ($(OPEN_ANYSDK),1)
LOCAL_SRC_FILES +=../../../Classes/anysdk/anysdkbindings.cpp
LOCAL_SRC_FILES +=../../../Classes/anysdk/anysdk_manual_bindings.cpp
endif

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../Classes


# _COCOS_HEADER_ANDROID_BEGIN
# _COCOS_HEADER_ANDROID_END

LOCAL_STATIC_LIBRARIES := cocos2d_lua_static

LOCAL_STATIC_LIBRARIES += cocos_curl_static

# _COCOS_LIB_ANDROID_BEGIN

#引入AnySDK全局静态库, 必须放在 include $(BUILD_SHARED_LIBRARY) 之前
ifeq ($(OPEN_ANYSDK),1)
LOCAL_WHOLE_STATIC_LIBRARIES += PluginProtocolStatic
endif

# _COCOS_LIB_ANDROID_END



include $(BUILD_SHARED_LIBRARY)


$(call import-module,scripting/lua-bindings/proj.android)

$(call import-module,./curl/prebuilt/Android)


# _COCOS_LIB_IMPORT_ANDROID_BEGIN

#加载 AnySDK 模块
ifeq ($(OPEN_ANYSDK),1)
$(call import-add-path,$(HLB_DIR)/../)
$(call import-module,protocols/android)
endif

# _COCOS_LIB_IMPORT_ANDROID_END








