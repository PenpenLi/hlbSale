
local Account = {}
setmetatable(Account,{__index = _G})
setfenv(1,Account)

local m_serverList        --所有服务器列表
local m_histroySerList    --用户登录过的服务器列表,用于游戏内切换不同区服务器
local m_curArea           --当前选择哪个区
local m_httpHost          --当前使用服务器地址
local m_tcpHost           --当前使用长连接服务器地址
local m_channelUid        --登录渠道返回的uid
local m_loginHashCode     --每次登录在checkPlayer时服务器会下发新的登陆码
local m_platform 

--所有服务器列表
function setServerList(srvList)
  m_serverList = srvList 
end 

function getServerList()
  return m_serverList 
end 

function setHistoryServerList(srvList)
  m_histroySerList = srvList 
end 

function getHistoryServerList()
  return m_histroySerList 
end 

--当前选择哪个区(即服务器列表索引)
function setCurrentArea(index)
  m_curArea = index 
end 

function getCurrentArea()
  return m_curArea 
end 

--当前游戏服http域名
function setHttpHost(host)
  m_httpHost = host
end

function getHttpHost()
  return m_httpHost
end

--当前游戏服tcp域名
function setTcpHost(host)
  m_tcpHost = host
end

function getTcpHost()
  return m_tcpHost
end

--渠道UID,由渠道服务器返回
function setChannelUID(uid)
  m_channelUid = uid
end 

function getChannelUID()
  return m_channelUid 
end 

--登录校验码,当进入游戏服checkplayer的时候校验用,
--当两台设备同时登录时, 用来踢掉之前的账号
function setLoginHashCode(code)
  m_loginHashCode = code 
end 

function getLoginHashCode()
  return m_loginHashCode 
end 

--当前是否测试用户(即属于登录服下发的白名单中)
function isTestUser()
  if m_serverList then 
    return m_serverList.whitelist_flag == 1 
  end 

  return false 
end 

function getPlatform()
  local str = ""
  local target = cc.Application:getInstance():getTargetPlatform()
  if target == cc.PLATFORM_OS_WINDOWS then 
    str = "Win32"
  elseif target == cc.PLATFORM_OS_ANDROID then
    str = "Android" 
  elseif target == cc.PLATFORM_OS_IPAD then 
    str = "Ipad"
  else
    str = "ios" 
  end 
  return str 
end 








return Account 
