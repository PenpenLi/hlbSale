
cc.FileUtils:getInstance():setPopupNotify(false)

require "config"
require "cocos.init"
require "game.InitGloable"

math.randomseed(os.time())

local function main()
  g_viewManager.setScene(g_consts.SceneType.game) 
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
  print(msg)
end
