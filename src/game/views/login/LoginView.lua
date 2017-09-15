
--登录界面:
--流程如下: 1)从登录服获取游戏服列表   2)登录平台  3)登录游戏
local LoginView = class("LoginView",require("game.views.base.BaseLayer"))
local LoginMode = require("game.views.login.LoginMode")

function LoginView:ctor()
  LoginView.super.ctor(self)

end 

function LoginView:onEnter()

  local layer = g_gameTool.loadCocosUI("csb/login/login.csb", 5)
  if layer then 
    local btn = layer:getChildByName("scale_node"):getChildByName("Button_1") 
    self:regBtnCallback(btn, handler(self, self.onReqServerList)) 
    self:addChild(layer)
  end 
end 

function LoginView:onExit() 
end 

--case 1 
function LoginView:onReqServerList()
  print("onReqServerList")
  local function onSuccess()
    print("onSuccess") 
    self:onSDKLogin()
  end 
  LoginMode.requestServerList(onSuccess)
end 

--case 2
function LoginView:onSDKLogin()
  print("onSDKLogin")
  --todo 

  self:checkPlayer()
end 

--case 3
--检测玩家是否存在,如果不存在则创建,返回login_hash_code,
--如果之前已经在其他设备登录,则将它踢下线,并登录游戏
function LoginView:checkPlayer() 
  print("checkPlayer")
  local function onSuccess()
    self:onLoading() 
  end   
  LoginMode.reqCheckPlayer(onSuccess) 
end 


function LoginView:onLoading()
  print("onLoading")
  -- g_viewManager.setScene(g_consts.SceneType.game) 
  g_viewManager.setScene(g_consts.SceneType.loading) 
end 




return LoginView 
