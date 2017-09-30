local LoginMode = {}
setmetatable(LoginMode,{__index = _G})
setfenv(1,LoginMode)


--从登录服务器获取游戏服URL(包括http 和 tcp)
function requestServerList(successHandler)

  local function onRecv(result, msgData)
    g_busyTip.hide_1() 

    if true then 
      dump(msgData, "==msgData")
      local gameServerList = cjson.decode(msgData)
      dump(gameServerList, "gameServerList") 
      g_account.setServerList(gameServerList)

      --test
      g_account.setHttpHost(gameServerList.server_list[1].game_server_host)
      g_account.setTcpHost(gameServerList.server_list[1].net_server_host)

      if successHandler then
        successHandler(gameServerList)
      end 
    else 
      g_msgBox.show(g_tr("getServerListFail"), nil, nil, function(eventType) 
          if eventType == 0 then --重试
            requestServerList(successHandler)
          end 
        end, 1, {str1 = g_tr("msgBox_retry")})
    end 
  end 
  g_busyTip.show_1()

  local para = ""
  local url = g_gameConfig.loginHost .. "/login_server/getServerList" 
  HttpNet:getInstance():post(url, para, string.len(para), onRecv, 12, 12, true, false) --异步请求, 参数不加密
end 


--当进入游戏服时校验玩家合法性和唯一性 
function reqCheckPlayer(successCallback)
  local function onRecv(result, msgData)
    g_busyTip.hide_1() 
    if result then 
      dump(msgData, "==msgData")
      g_account.setLoginHashCode(msgData.login_hashcode)

      if successCallback then 
        successCallback(msgData)
      end 
    end 
  end 

  local para = {
    platform = g_account.getPlatform()
  } 
  g_http.postData("common/checkPlayer", para, onRecv, true) 
  g_busyTip.show_1()
end 

function logout()
  -- reset()
  -- sdkLogout()
  g_cacheFile.saveToFile()()
end

return LoginMode
