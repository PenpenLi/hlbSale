
local TcpNet = {}
setmetatable(TcpNet,{__index = _G})
setfenv(1, TcpNet)


--说明：
--[[
    registNotifyHandler() /unregistNotifyHandler()  ---针对服务器返回的 notifyXXX通知
    registMsgCallback() / unregistMsgCallback()     ---消息注册与反注册
    unregistAllCallback(target)                     ---清楚指定对象所有注册的 notifyXXX 和 消息
    sendReq()       ---向服务器发送 reqXXX 事件
    sendMessage()   ---向服务器发送消息
--]]


--TcpNetNotifyEnum of "NetCommon.h"
local NotifyConnectingLoginServerFail = 200002
local NotifyConnectedLoginServer      = 200003
local NotifyConnectingGameServerFail  = 200004
local NotifyConnectedGameServer       = 200005
local NotifyDisconnected              = 200006
local NotifyRecvMsg                   = 200007

--UserReqEnum of "NetCommon.h"
local ReqConnectLoginServer           = 100002
local ReqConnectGameServer            = 100003
local ReqSendData                     = 100004
local ReqDisconnect                   = 100005

local m_heartBeatInterval             = 5.0
local m_maxHeartBeatTimeoutCount      = 0
local m_maxHeartBeatTimeout           = 10.0

local m_isConnected                   = false
local m_heartBeatTimeoutCount         = 0
local m_lastHeartBeatTime             = 0

local m_notifyHandler                 = {}
local m_msgCallback                   = {}

local m_heartBeatTimerId
local m_loopTimerId


function setLoginServerAddr(ip,port)
  c_setup_login_server(ip, port)
end

function setGameServerAddr(ip,port)
  c_setup_game_server(ip, port)
end

function dumpCallback()
end 

function onRecvMsgData(msgId, jsonData)
  if msgId then 
    local t = m_msgCallback[msgId]
    if t then 
      for k, v in pairs(t) do 
        v.func(v.target, msgId, jsonData)
      end 
    end 
  end 
end 


--notify regist
function registNotifyHandler(notify, target, handler)
  if m_notifyHandler[notify] == nil then 
    m_notifyHandler[notify] = {}
  end 

  table.insert(m_notifyHandler[notify], {target = target, func = handler})
end

--msg regist
function registMsgCallback(msgId,target,callback)
  if m_msgCallback[msgId] == nil then 
    m_msgCallback[msgId] = {}
  end 

  for k, v in pairs(m_msgCallback[msgId]) do 
    if v.target == target and v.func == callback then 
      return 
    end 
  end 
  table.insert(m_msgCallback[msgId], {target = target, func = callback})
end

function unregistNotifyHandler(notify, target)
  local handler = m_notifyHandler[notify]
  if handler then 
    for k, v in pairs(handler) do 
      if v.target == target then 
        handler[k] = nil 
      end
    end 
  end 
end 

function unregistMsgCallback(msgId, target)
  local callback = m_msgCallback[msgId]
  if callback then 
    for k, v in pairs(callback) do 
      if v.target == target then 
        callback[k] = nil 
      end
    end 
  end   
end 

function unregistAllCallback(target)
  if target == nil then 
    print("unregistAllCallback Error : target is nill...")
    return 
  end 

  for i, hander in pairs(notifyHandler) do 
    for k, v in pairs(hander) do 
      if v.target == target then 
        m_notifyHandler[i][k] = nil 
      end
    end 
  end 

  for i, callback in pairs(m_msgCallback) do 
    for k, v in pairs(callback) do 
      if v.target == target then 
        m_msgCallback[i][k] = nil 
      end
    end 
  end 
end 

--default handlers
registNotifyHandler(NotifyConnectingLoginServerFail, nil, dumpCallback)
registNotifyHandler(NotifyConnectedLoginServer, nil, dumpCallback)
registNotifyHandler(NotifyConnectingGameServerFail, nil, dumpCallback)
registNotifyHandler(NotifyConnectedGameServer, nil, dumpCallback)
registNotifyHandler(NotifyDisconnected, nil, dumpCallback)
registNotifyHandler(NotifyRecvMsg, nil, onRecvMsgData)


function pickNotify()
  if c_pick_notify ~= nil then
    local notify, msgId, jsonData = c_pick_notify()
    if notify ~= nil then

      if msgId ~= g_consts.NetMsg.HeartBeatRsp then 
        print("pickNotify: notify, msgId", notify, msgId)
      end 

      --解析json数据
      -- dump(jsonData, "===jsonData")
      if jsonData and jsonData ~= "" then 
        jsonData = cjson.decode(jsonData)
      end 

      local handlers = m_notifyHandler[notify]
      if handlers then 
        for k, v in pairs(handlers) do 
          if v.target then 
            v.func(v.target, msgId, jsonData)
          else 
            v.func(msgId, jsonData)
          end   
        end 
      end   
    end    
  else
    print("you should implement c function c_pick_notify()")
  end
end


function sendReq(reqType, msgId, data)
  local jsonData
  if data then 
    jsonData = cjson.encode(data)
  end 
  c_send_req(reqType, msgId, jsonData)
end 

function sendMessage(msgId,data)
  sendReq(ReqSendData, msgId, data)
end


-----------------------------心跳包----------------------------
--超时无响应则断开连接
function keepAlive()

  if m_isConnected == true then 

    if m_lastHeartBeatTime == 0 then
      m_lastHeartBeatTime = os.time()
    end
    local duration = os.time() - m_lastHeartBeatTime
    if duration >= m_maxHeartBeatTimeout then -- timeout      
      m_heartBeatTimeoutCount = m_heartBeatTimeoutCount + 1

      if m_heartBeatTimeoutCount > m_maxHeartBeatTimeoutCount then
        print("heart beat: send disconnect req")
        sendReq(ReqDisconnect) --TcpNetManager will change to disconnecting state, then game server task break, and notify user
      end
    else
      m_heartBeatTimeoutCount = 0
    end
    
    --发送心跳包
    sendHeartBeat()
  end
end

--收到心跳包时的回调, 复位
function onRecvHeartBeatRsp()
  m_heartBeatTimeoutCount = 0
  m_lastHeartBeatTime = 0
end

--发送心跳包消息, 可以在其他地方重载此方法.
function sendHeartBeat()
  -- print("sendHeartBeat")
  sendMessage(g_consts.NetMsg.HeartBeatReq, {id = g_PlayerMode.GetData().id })
end
---------------------------------------------------------------



function loop()
  print("TcpNet.loop")
  local scheduler = cc.Director:getInstance():getScheduler()
  if m_loopTimerId then 
    scheduler:unscheduleScriptEntry(m_loopTimerId) 
  end   
  m_loopTimerId = scheduler:scheduleScriptFunc(pickNotify, 0.5, false)
end 

function connect()
  if m_isConnected == false then
    -- sendReq(ReqConnectLoginServer) 
    sendReq(ReqConnectGameServer) 
  else
    print("already conected to game server.")
  end
end

function disConnect()
  pause()
  sendReq(ReqDisconnect)
  m_isConnected = false 
end 

function startHeartBeat()
  print("startHeartBeat...")
  m_heartBeatTimeoutCount = 0 
  m_lastHeartBeatTime = 0

  local scheduler = cc.Director:getInstance():getScheduler()
  if m_heartBeatTimerId then 
    scheduler:unscheduleScriptEntry(m_heartBeatTimerId) 
  end 
  
  m_heartBeatTimerId = scheduler:scheduleScriptFunc(keepAlive, m_heartBeatInterval, false)
  registMsgCallback(g_consts.NetMsg.HeartBeatRsp, TcpNet, onRecvHeartBeatRsp)
end 

function pause()
  local scheduler = cc.Director:getInstance():getScheduler()
  if m_loopTimerId then 
    scheduler:unscheduleScriptEntry(m_loopTimerId) 
    m_loopTimerId = nil 
  end 
  if m_heartBeatTimerId then 
    scheduler:unscheduleScriptEntry(m_heartBeatTimerId) 
    m_heartBeatTimerId = nil 
  end  
end 

function resume()
  loop()
  startHeartBeat()
end 

function setConnectState(isConnected)
  m_isConnected = isConnected 
end 

return TcpNet 
