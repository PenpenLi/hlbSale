
local TcpInit = {}
setmetatable(TcpInit,{__index = _G})
setfenv(1,TcpInit)

local delayConnectTimer 


--建立与服务器的长连接通讯
function tcpNetInit()
  print("tcpNetInit")
  
  local function onConnectedGameServer()
    print("=== start send login msg")
    -- local uuid, md5 = g_http.getUUID() 
    -- local player = g_PlayerMode.GetData()
    -- local id = player and player.id or nil 
    -- local md5 = id and PSDeviceInfo:getMD5String(id) or nil 
    -- g_tcp.sendMessage(g_consts.NetMsg.LoginReq, {uuid=uuid, player_id = id, hash_code = md5})

    local id = 1234
    g_tcp.sendMessage(g_consts.NetMsg.LoginReq, {uuid = "uuid_hlb", player_id = id, hash_code = GameUtil:getMD5String(id.."md5_suffix")})
  end 

  local function onDisconnectedGameServer()
    print("onDisconnectedGameServer")
    g_tcp.setConnectState(false) 

    --当前网络差, 通知用户
    g_eventDispatch.sendEvent(g_consts.CustomEvent.PoorNetWork, {is_poor = true}) 

    --断开自动重连
    local scheduler = cc.Director:getInstance():getScheduler()
    local function autoConnectServer()
      print("autoConnectServer")
      if delayConnectTimer then 
        scheduler:unscheduleScriptEntry(delayConnectTimer) 
        delayConnectTimer = nil 
      end        
      g_tcp.connect() 
    end 
        
    if delayConnectTimer then 
      scheduler:unscheduleScriptEntry(delayConnectTimer) 
    end 
    delayConnectTimer = scheduler:scheduleScriptFunc(autoConnectServer, 5.0, false)
  end 
  
  local function onLoginRsp(target, msgid, data)
    print("onLogin success ...")
    if delayConnectTimer then 
      cc.Director:getInstance():getScheduler():unscheduleScriptEntry(delayConnectTimer) 
      delayConnectTimer = nil 
    end 

    g_tcp.setConnectState(true) 
    g_tcp.startHeartBeat() 
    
    g_eventDispatch.sendEvent(g_consts.CustomEvent.PoorNetWork, {is_poor = false}) 
  end 

  local function onRecvPushRsp(target, msgid, data)
    print("onRecvPushRsp: msgid", msgid)
    
    if nil == data then return end 

    --派发事件
    if data.type == "mail" then 
      --g_eventDispatch.sendEvent(g_consts.CustomEvent.NewMail, data)
    end 
  end 

  --连接 net 服务器 
  g_tcp.loop()
 
  local addr = string.gsub(g_account.getTcpHost(), "http://", "") --去掉http://
  local pos = string.find(addr, ":", 6)
  if pos then 
    local host = string.sub(addr, 1, pos-1)
    local port = tonumber(string.sub(addr, pos+1))
    print("sgNetInit, host, port", host, port)

    g_tcp.setGameServerAddr(host, port)
    g_tcp.connect()

    g_tcp.registNotifyHandler(g_tcp.NotifyConnectedGameServer, TcpInit, onConnectedGameServer)
    g_tcp.registNotifyHandler(g_tcp.NotifyDisconnected, TcpInit, onDisconnectedGameServer)
    g_tcp.registNotifyHandler(g_tcp.NotifyConnectingGameServerFail, TcpInit, onDisconnectedGameServer)

    g_tcp.registMsgCallback(g_consts.NetMsg.LoginRsp, TcpInit, onLoginRsp) 
    g_tcp.registMsgCallback(g_consts.NetMsg.DataSendRsp, TcpInit, onRecvPushRsp) 
  end 
end 

--断开长连接
function tcpNetDeinit()
  g_tcp.disConnect()
end 



return TcpInit 
