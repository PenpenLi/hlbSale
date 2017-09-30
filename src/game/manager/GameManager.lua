
local GameManager = {}
setmetatable(GameManager,{__index = _G})
setfenv(1,GameManager)

--重启游戏
function reStartGame()
  print("reStartGame")

  g_resManager.removeAllCocosAniFileInfo()
  require("network.TcpInit").tcpNetDeinit()

  for path, tmp in pairs(package.loaded) do 
    if string.find(path, "cocos%.") == 1 then 
      package.loaded[path] = nil 
    elseif string.find(path, "data%.") then 
      package.loaded[path] = nil 
    elseif string.find(path, "game%.") then 
      package.loaded[path] = nil 
    elseif string.find(path, "network%.") then 
      package.loaded[path] = nil 
    end 
  end 
end 

--退出游戏
function exitGame()
  local target = cc.Application:getInstance():getTargetPlatform()
  if target == cc.PLATFORM_OS_IPHONE or target == cc.PLATFORM_OS_IPAD then
    os.exit(0)
  else
    cc.Director:getInstance():endToLua()
  end
end


--程序进入/退出后台处理
local m_enterBgTime = os.time() 
local function onAppEnterBackground() 
  print("=== onAppEnterBackground")
  m_enterBgTime = os.time()

  if g_audioManager then
    g_audioManager.onDidEnterBackground()
  end

end 

local function onAppEnterForeground() 
  print("=== onAppEnterForeground")
  if g_audioManager then
    g_audioManager.onWillEnterForeground()
  end 

  local elapseTime = os.time() - m_enterBgTime 
  if elapseTime > 60 then --大于60秒则同步服务器时间
    --todo 
  end 

  if elapseTime > 20 then --根据需要重新同步游戏中的数据
    --todo 
  end 
end 
local listener1 = cc.EventListenerCustom:create("APP_ENTER_BACKGROUND_EVENT", onAppEnterBackground)
local listener2 = cc.EventListenerCustom:create("APP_ENTER_FOREGROUND_EVENT", onAppEnterForeground)
cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(listener1, 1)
cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(listener2, 1)




return GameManager
