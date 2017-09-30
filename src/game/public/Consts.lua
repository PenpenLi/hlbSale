

--(全局)常量

local constsMode = {}
setmetatable(constsMode,{__index = _G})
setfenv(1,constsMode)


SceneType = {
  none    = 1, 
  login   = 2, 
  loading = 3, 
  game    = 4, 
}


--货币类型
Currency = {
  ["Money"] = 1,   --元宝
}


--长连接消息id
NetMsg = {
  ["LoginReq"]          = 100,  --登录
  ["LoginRsp"]          = 101, 
  ["HeartBeatReq"]      = 102,  --心跳包
  ["HeartBeatRsp"]      = 103,
  ["HeartBeatPauseReq"] = 104,  --心跳暂停检测
  ["HeartBeatPauseRsp"] = 105,
  ["DataSendReq"]       = 106,  --通用的数据交互, 可用于服务端推送事件
  ["DataSendRsp"]       = 107,
  ["ChatSendReq"]       = 108,  --发送聊天数据
  ["ChatSendRsp"]       = 109,  
}


--用户事件枚举
CustomEvent = {
  PoorNetWork    = 1,
  NewMail        = 2,
  Chat           = 3,
  SdkLoginResult = 4,
  SdkPayResult   = 5,
}


--声音路径
AudioPath = {
  MusicBackground = g_data.audio[1001].sounds_path, --背景音乐
  EffectConfirm   = g_data.audio[1002].sounds_path, --默认确定音效
  EffectCancel    = g_data.audio[1003].sounds_path, --默认取消音效
}






return constsMode