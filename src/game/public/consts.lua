

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
  ["LoginReq"]      = 10000,       --登录
  ["LoginRsp"]      = 10001, 
  ["HeartBeatReq"]  = 10002,   --心跳包
  ["HeartBeatRsp"]  = 10003,
  ["ServerPushReq"] = 10004,  --后台推送
  ["ServerPushRsp"] = 10005,
  ["ChatSendReq"]   = 10008,    --聊天
  ["ChatSendRsp"]   = 10009,

}


--用户事件枚举
CustomEvent = {
  NewMail    = 1,
  Chat       = 2,
  Guild_Help = 3,
}


--声音路径
AudioPath = {
  MusicBackground = g_data.audio[1001].sounds_path, --背景音乐
  EffectConfirm   = g_data.audio[1002].sounds_path, --默认确定音效
  EffectCancel    = g_data.audio[1003].sounds_path, --默认取消音效
}






return constsMode