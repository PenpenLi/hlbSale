local RequestManager = {}
setmetatable(RequestManager,{__index = _G})
setfenv(1,RequestManager)



--错误码提示
function onRequestAutoErrorCodeTips(errorId)
  local errcode = g_data.error_code[tonumber(errorId)]
  if errcode then
    local text = errcode[require("game.localization").language]
    if text then
      g_toast.show(text, 3)
      return
    end
  end

  g_toast.show("error: not found error_id : "..tostring(errorId), 3)
end

--服务器带回数据自动更新UI
function onRequestAutoUpdate(basicTable)

end


-- local dataList = 
-- {
--   "Player",
--   "PlayerBuild",
--   "PlayerMission",
-- }

--请求data/index数据
function RequestDataIndex(dataList)
  local ret = false
  local function onRecv(result, msgData)
    ret = result 
    if result then
      onRequestAutoUpdate(msgData)
    end
  end
  g_http.postData("data/index",{name = dataList}, onRecv)
  return ret
end


return RequestManager
