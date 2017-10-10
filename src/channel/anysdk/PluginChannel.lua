
--anysdk用户接口
require "channel.anysdk.init"
local PluginChannel = class("PluginChannel")

local m_instance = nil

local user_plugin = nil
local iap_plugin_maps = nil
local share_plugin = nil


function PluginChannel:getInstance()
  if m_instance == nil and AgentManager then
    m_instance = PluginChannel.new()
  end
  return m_instance
end


--登录事件处理
local function onUserResult( plugin, code, msg )
  print("PluginChannel:onUserResult:, code, msg=", code, msg)

  if code == UserActionResultCode.kInitSuccess then
    --do
  elseif code == UserActionResultCode.kInitFail then
    --do
  elseif code == UserActionResultCode.kLoginSuccess then
    g_account.setChannelUID(user_plugin:getUserID()) 
    if msg and msg ~= "" then 
      local dataTable = cjson.decode(msg)
      -- g_account.setHistoryServerList(dataTable.ext)
    end 
    g_sdkManager.onLoginSuccess(g_sdkManager.loginChannel.anysdk)

  elseif code == UserActionResultCode.kLoginNetworkError then
    --do
  elseif code == UserActionResultCode.kLoginNoNeed then
    --do
  elseif code == UserActionResultCode.kLoginFail then
    --do
  elseif code == UserActionResultCode.kLoginCancel then
    --do
  elseif code == UserActionResultCode.kLogoutSuccess then
    g_gameManager.reStartGame() 

  elseif code == UserActionResultCode.kLogoutFail then
    --do
  elseif code == UserActionResultCode.kPlatformEnter then
    --do
  elseif code == UserActionResultCode.kPlatformBack then
    --do
  elseif code == UserActionResultCode.kPausePage then
    --do
  elseif code == UserActionResultCode.kExitPage then
    if msg == "onGameExit" or msg == "onNo3rdExiterProvide" then --弹出游戏退出界面 
    else
      if g_viewManager.getCurSceneType() == g_consts.SceneType.game then --不知道做什么用!!!fuck
        g_sdkManager.submitRoleData(g_sdkManager.loginChannel.anysdk)
      end
      g_gameManager.exitGame()
    end
  elseif code == UserActionResultCode.kGameExitPage then
    --弹出游戏退出界面
  elseif code == UserActionResultCode.kAntiAddictionQuery then
    --do
  elseif code == UserActionResultCode.kRealNameRegister then
    --do
  elseif code == UserActionResultCode.kAccountSwitchSuccess then
    g_gameManager.reStartGame()
  elseif code == UserActionResultCode.kAccountSwitchFail then
    --do
  elseif code == UserActionResultCode.kOpenShop then
    --do
  end
end

--支付事件处理
local function onPayResult( code, msg, info )
  print("on iap result listener.")
  print("code:"..code..",msg:"..msg)

  if code == PayResultCode.kPaySuccess then
    g_msgBox.show(g_tr("paySuccess"))
    g_sdkManager.onPaySuccess(g_sdkManager.loginChannel.anysdk)

  elseif code == PayResultCode.kPayFail then
    g_msgBox.show(g_tr("payFail"))

  elseif code == PayResultCode.kPayCancel then
    g_msgBox.show(g_tr("payCancel"))

  elseif code == PayResultCode.kPayNetworkError then
    g_msgBox.show(g_tr("payNetError"))

  elseif code == PayResultCode.kPayProductionInforIncomplete then
    g_msgBox.show(g_tr("payInfoNotComplete"))

  elseif code == PayResultCode.kPayInitSuccess then
    --do
  elseif code == PayResultCode.kPayInitFail then
    --do
  elseif code == PayResultCode.kPayNowPaying then
    --do
  elseif code == PayResultCode.kPayRechargeSuccess then
    --do
  end
end

--分享事件处理
local function onShareResult(code, msg)
  print("PluginChannel:onShareResult: code, msg =", code, msg)
  if code == ShareResultCode.kShareSuccess then
    --do
  elseif code == ShareResultCode.kShareFail then
    --do
  elseif code == ShareResultCode.kShareCancel then
    --do
  elseif code == ShareResultCode.kShareNetworkError then
    --do
  end 
end

--初始化
--需要配置 appKey, appSecret, privateKey, oauthLoginServer
function PluginChannel:ctor()
  assert(nil == m_instance,"pls use 'getInstance' function instead")

  --for anysdk
  local agent = AgentManager:getInstance()
  --init
  local appKey = "D1D7F392-D015-5507-5144-9383623E7A32"
  local appSecret = "0b417396781b054b34a8e626c5ad95d7"
  local privateKey = "48C60F3704520718F12F972235378289"
  local oauthLoginServer = g_gameConfig.loginHost.."/login_server/loginAnySDK"
    
  agent:init(appKey, appSecret, privateKey, oauthLoginServer)

  local targetPlatform = cc.Application:getInstance():getTargetPlatform()
  if targetPlatform ~= cc.PLATFORM_OS_ANDROID then
    --load
    --Android建议在onCreate里调用PluginWrapper.loadAllPlugins();来进行插件初始化
    agent:loadAllPlugins()
  end
  
  --用户
  -- get user plugin
  user_plugin = agent:getUserPlugin()
  if user_plugin ~= nil then
    user_plugin:setActionListener(onUserResult)
  end
  
  --支付
  --因为AnySDK支持多种支付方式，所以通过getIAPPlugin获取所有的支付插件
  --如果使用多种支付方式，还需要自己处理相关UI及界面
  iap_plugin_maps = agent:getIAPPlugin()
  local iapPluginNums = table.nums(iap_plugin_maps) 
  if iapPluginNums == 1 then
    for key, value in pairs(iap_plugin_maps) do
      print("key:" .. key)
      print("value: " .. type(value))
      value:setResultListener(onPayResult)
    end
  else
    print("包含"..iapPluginNums.."个支付插件！") 
  end

  --分享
  share_plugin = agent:getSharePlugin()
  if share_plugin ~= nil then
    share_plugin:setResultListener(onShareResult)
  end

  agent:setIsAnaylticsEnabled(true)
end


--一定要接到初始化SDK成功回调，才可以调登录接口的函数
--方法一：login()；
--方法二：login(info)； //param:info(map)
--登陆参数可以传入一个 map，可传入服务器 ID（server_id）、登陆验证地址（server_url）和透传参数（任意 key 值）。
--服务器 ID：key 为 server_id，服务端收到的参数名为 server_id，不传则默认为 1。
--登陆验证地址：key 为 server_url，传入的地址将覆盖掉配置的登陆验证地址。
--透传参数：key 任意（以上两个 key 除外），服务端收到的参数名为 server_ext_for_login，是个 JSON 字符串。
--PS：AnySDK 客户端 渠道参数 的 登陆验证透传参数，服务端收到的参数名为 server_ext_for_client。
function PluginChannel:login()
  if user_plugin ~= nil then
    user_plugin:removeListener()
    user_plugin:setActionListener(onUserResult)
    local paramMap = {
      server_id = "1",
      server_url = g_gameConfig.loginHost.."/login_server/loginAnySDK" --传入的地址将覆盖init()函数时配置的登陆验证地址
    }
    
    user_plugin:login(paramMap)
  end
end

function PluginChannel:getUserPlugin()
  return user_plugin
end

function PluginChannel:getUserID()
  local userId = nil
  if user_plugin ~= nil then
    userId = user_plugin:getUserID()
  end
  return userId
end

function PluginChannel:isLogined()
  local isLogined = false
  if user_plugin ~= nil then
    isLogined = user_plugin:isLogined()
  end
  return isLogined
end

function PluginChannel:logout()
  if user_plugin ~= nil then
    if user_plugin:isFunctionSupported("logout") then
      user_plugin:callFuncWithParam("logout")
    end
  end
end

function PluginChannel:enterPlatform()
  if user_plugin ~= nil then
    if user_plugin:isFunctionSupported("enterPlatform") then
      user_plugin:callFuncWithParam("enterPlatform")
    end
  end
end

function PluginChannel:showToolBar()
  if user_plugin ~= nil then
    if user_plugin:isFunctionSupported("showToolBar") then
      local param1 = PluginParam:create(ToolBarPlace.kToolBarTopLeft)
      user_plugin:callFuncWithParam("showToolBar", param1)
    end
  end
end

function PluginChannel:hideToolBar()
  if user_plugin ~= nil then
    if user_plugin:isFunctionSupported("hideToolBar") then
      user_plugin:callFuncWithParam("hideToolBar")
    end
  end
end

function PluginChannel:accountSwitch()
  if user_plugin ~= nil then
    if user_plugin:isFunctionSupported("accountSwitch") then
      user_plugin:callFuncWithParam("accountSwitch")
    end
  end
end

function PluginChannel:realNameRegister()
  if user_plugin ~= nil then
    if user_plugin:isFunctionSupported("realNameRegister") then
      user_plugin:callFuncWithParam("realNameRegister")
    end
  end
end

function PluginChannel:antiAddictionQuery()
  if user_plugin ~= nil then
    if user_plugin:isFunctionSupported("antiAddictionQuery") then
      user_plugin:callFuncWithParam("antiAddictionQuery")
    end
  end
end

function PluginChannel:submitLoginGameRole(info)
  if user_plugin ~= nil then
    if user_plugin:isFunctionSupported("submitLoginGameRole") then
      
      local data = PluginParam:create(info)
      user_plugin:callFuncWithParam("submitLoginGameRole", data)
    end
  end
end

function PluginChannel:pay(info)
  if iap_plugin_maps ~= nil then
    
    -- analytics_plugin:logEvent("pay", info)
    ProtocolIAP:resetPayState()
    for key, value in pairs(iap_plugin_maps) do
      print("key:" .. key)
      print("value: " .. type(value))
      value:payForProduct(info)
    end
  end
end

function PluginChannel:exit()
  if nil ~= user_plugin and user_plugin:isFunctionSupported("exit") then
    user_plugin:callFuncWithParam("exit")
  else
    g_sdkManager.alertExitGame()
  end
end

function PluginChannel:share()
  if share_plugin ~= nil then
    local info = {
      title = g_tr("share_title"),--title 标题，印象笔记、邮箱、信息、微信、人人网和 QQ 空间使用
      --titleUrl = "http://sharesdk.cn ",--titleUrl 是标题的网络链接，仅在人人网和 QQ 空间使用
      --site = "ShareSDK",--site 是分享此内容的网站名称，仅在 QQ 空间使用
      --siteUrl = "http://sharesdk.cn ",--siteUrl 是分享此内容的网站地址，仅在 QQ 空间使用
      imagePath = "/sdcard/somethingbig_sg2_share.png",--imagePath 是图片的本地路径，Linked-In 以外的平台都支持此参数（imagePath 和 imageUrl 2选1）
      --url = g_tr("share_url"), --url 仅在微信（包括好友和朋友圈）中使用
      --imageTitle = "ssdd",
      imageUrl = g_tr("share_image_url"),--imageUrl 是图片的网络路径，新浪微博，人人网，QQ 空间支持此字段
      text = g_tr("share_text"),--text 是分享文本，所有平台都需要这个字段
      --comment = "无",--comment 是我对这条分享的评论，仅在人人网和 QQ 空间使用
      --mediaType = "1",--微信 SDK 需要是用到的参数，分享类型： 0 - 文字 1 - 图片 2 - 网址
      --shareTo = "2",--微信 SDK 需要是用到的参数，分享到：0 - 聊天 1 - 朋友圈 2 - 收藏
      --description = "ffff",
    }
    
    share_plugin:share(info)
  end
end

return PluginChannel