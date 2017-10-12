
--登录界面:
--流程如下: 1)从登录服获取游戏服列表   2)登录平台  3)登录游戏
local LoginView = class("LoginView",require("game.views.base.BaseLayer"))
local LoginMode = require("game.views.login.LoginMode")

function LoginView:ctor()
  LoginView.super.ctor(self)

end 

function LoginView:onEnter()
  print("LoginView:onEnter")

  local layer = g_gameTool.loadCocosUI("csb/login/login.csb", 5)
  if layer then 
    local btn = layer:getChildByName("scale_node"):getChildByName("Button_1") 
    local btn2 = layer:getChildByName("scale_node"):getChildByName("Button_2") 
    self:regBtnCallback(btn, handler(self, self.onReqServerList)) 
    self:regBtnCallback(btn2, handler(self, self.onWeiXinShare)) 
    self:addChild(layer)
  end 

  g_eventDispatch.addEventHandler(g_consts.CustomEvent.SdkLoginResult, handler(self, self.onSdkLoginResult))
end 

function LoginView:onExit() 
  print("LoginView:onExit")
  g_eventDispatch.removeEventHandler(g_consts.CustomEvent.SdkLoginResult, self)
end 

--case 1 
function LoginView:onReqServerList()
  print("onReqServerList")

  LoginMode.requestServerList(handler(self, self.onSDKLogin))
end 

--case 2
function LoginView:onSDKLogin()
  print("onSDKLogin") 
  g_sdkManager.sdkLogin(g_sdkManager.loginChannel.anysdk)
end 

--case 3
--检测玩家是否存在,如果不存在则创建,返回login_hash_code,
--如果之前已经在其他设备登录,则将它踢下线,并登录游戏
function LoginView:checkPlayer() 
  print("checkPlayer")  
  LoginMode.reqCheckPlayer(handler(self, self.loadingResource))
end 

--case 4
--加载资源进入游戏
function LoginView:loadingResource()
  print("loadingResource")
  -- g_viewManager.setScene(g_consts.SceneType.game) 
  g_viewManager.setScene(g_consts.SceneType.loading) 
end 

--SDK登录成功则开始case 3, 检测玩家是否存在
function LoginView:onSdkLoginResult(target, data)
  print("onSdkLoginResult:", data.result)

  if data.result then 
    self:checkPlayer()
  else 
    print("sdk login fail ")
  end 
end 

function LoginView:onWeiXinShare()
  print("LoginView:onTestApi")

  local className="org/cocos2dx/lua/AppActivity"
  local funcName = "onWXShare"
  local function onResult(data) 
    if data == "true" then 
      local luaj = require "cocos.cocos2d.luaj"
      local arg="(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V" --中间不能有空格,否则调用失败
      local params = {"mytitle", "mydesc", "", "www.hao123.com", true}
      luaj.callStaticMethod(className, funcName, params, arg) 
    else 
      print("function "..funcName .."not exist !!!")
    end 
  end 
  g_gameTool.execJavaFunc(className, funcName, onResult)
end 

return LoginView 
