

cc.FileUtils:getInstance():setPopupNotify(false)

require "config"
require "socket" --必须放在 require "cocos.init" 之前,否则会有全局变量的检测提示
require "cocos.init"
require "game.InitGloable"

math.randomseed(os.time())

local function main() 
  g_viewManager.setScene(g_consts.SceneType.login) 
  -- g_viewManager.setScene(g_consts.SceneType.game) 
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
  print(msg)
end
