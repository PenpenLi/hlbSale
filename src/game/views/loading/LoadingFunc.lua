
local LoadingFunc = {}
setmetatable(LoadingFunc,{__index = _G})
setfenv(1,LoadingFunc)


--进入首页前需要调用的函数
--注意:
--各函数顺序执行,函数名不可重复
--每个函数都要做到可以重复调用,因为如果失败,可能会再次尝试调用
--函数中不要做任何计算操作,只允许将请求消息写入缓存,或者加载某些特定资源
--函数必须有bool返回值
--有任何一个调用结果为false都将阻止玩家进入游戏
--任务完成后必须调用 afterFuncExec() 来更新队列状态;

--对于网络请求,建议 g_http.postData()时使用异步来访问, 而设置jobQueue时必须填异步,如：
--{func = requestCombo, weight = 10, isASync = false}
--因此这是一种假同步,目的是为了不堵塞进程,分担系统负载,保证UI的流畅性;


--1) 批量网络请求
function requestCombo() 
  print("requestCombo")

  local comboList = {
    {url = "common/ntpdate", para = {} },
    {url = "test/getInfo", para = {item = 1234}}
  } 
  --转换为小写
  for k, v in pairs(comboList) do 
    comboList[k].url = string.lower(comboList[k].url)
  end 

  local function onRecv(result, msgData)
    if result then
      handleComboRsp(msgData)
    end
    afterFuncExec(result, requestCombo)
  end
  g_http.postData("common/combo",{combo = comboList}, onRecv, true)

  return true 
end 

function handleComboRsp(msgData) 
  for url, data in pairs(msgData) do 
    if url == "common/ntpdate" then 
      g_clock.setData(data) 
    end 
  end 
end 



--2) 批量请求 index 数据
function requestDataIndex()
  local list = {
    "Player",
    "PlayerInfo",
  } 
  local function onRecv(result, msgData)
    ret = result 
    if result then
      dump(msgData, "===requestDataIndex") --数据已经在网络底层Httplua.lua设置过了
      -- g_requestManager.updateBasicData(msgData)
    end
    afterFuncExec(result, requestDataIndex)
  end
  g_http.postData("data/index",{name = list}, onRecv, true) 
end 



--3)连接net服务器
function connectNetServer() 
  require("network/TcpInit").tcpNetInit()
  g_delayCall.addCocosList(function() afterFuncExec(true, connectNetServer) end )
  return true 
end



--4) 异步加载图片资源
function loadImgAsync() 
  local imgList = { 
    "res/ui/home/bg.jpg",
  } 
  local count = 0 
  local function imageLoaded()
    count = count + 1 
    if count == #imgList then 
      afterFuncExec(true, loadImgAsync)
    end 
  end 
  for k, path in pairs(imgList) do 
    cc.Director:getInstance():getTextureCache():addImageAsync(path, imageLoaded)
  end 
end 




-- function loadingMapRes_1()
-- 	cc.SpriteFrameCache:getInstance():addSpriteFrames("homeImage/homeImage.plist","homeImage/homeImage.png")
-- 	return true
-- end




------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------


local FuncQueue = require("game.public.FuncQueue")
local m_updateCallback

local jobQueue = {
  {func = requestCombo, weight = 10, isASync = false},
  {func = requestDataIndex, weight = 30, isASync = false},
  -- {func = connectNetServer, weight = 10, isASync = true},
  {func = loadImgAsync, weight = 20, isASync = true},
}


function startLoading(updateCallback)
  print("startLoading")
  m_updateCallback = updateCallback 
  FuncQueue.startProcess(jobQueue, function(result, percent)
      if m_updateCallback then 
        m_updateCallback(result, percent)
      end 
    end)
end 

function resumeLoading()
  print("resumeLoading")
  FuncQueue.resumeProcess()
end 

function afterFuncExec(result, func) 
  print("afterFuncExec") 
  if result then 
    FuncQueue.endOneSyncExec(func)
  else 
    FuncQueue.stopProcess()
  end 
end 


return LoadingFunc
