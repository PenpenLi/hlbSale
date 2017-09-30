
local SdkManager = {}
setmetatable(SdkManager,{__index = _G})
setfenv(1,SdkManager)

loginChannel = {
  anysdk  = 1,
  huawei  = 2, 
  aligame = 3,
}



local targetPlatform = cc.Application:getInstance():getTargetPlatform()


function sdkLogin(channel) 
  if channel == loginChannel.anysdk then 
    require("channel.anysdk.PluginChannel"):getInstance().login() 
  end 
end 

function sdkLogout()

end 

--登录成功,更新UI
function onLoginSuccess(channel)
  g_delayCall.addCocosList( function ()
      g_eventDispatch.sendEvent(g_consts.CustomEvent.SdkLoginResult, {result = true})
    end,
    0.1)
end 

--支付成功,更新UI
function onPaySuccess(channel) 
  g_delayCall.addCocosList( function ()
      g_eventDispatch.sendEvent(g_consts.CustomEvent.SdkPayResult, {result = true})
    end,
    0.1)
end 

--分享成功,更新UI 
function onShareSuccess() 

end 

function submitRoleData(channel) 
  if targetPlatform == cc.PLATFORM_OS_ANDROID then
    local userInfo = {
      level = g_playerData.getData().level 
    }

    if channel == loginChannel.anysdk then 
      require("anysdk.PluginChannel"):getInstance():submitLoginGameRole(userInfo)

    elseif channel == loginChannel.huawei then 
    elseif channel == loginChannel.aligame then 
    end 
  end 
end 

return SdkManager
