
local resManager = {}
setmetatable(resManager,{__index = _G})
setfenv(1,resManager)


function resManager.getSpritePath(id)
  local resInfo = g_data.sprite[tonumber(id)]
  assert(resInfo,"cannot found res info by id:"..id)
  return resInfo.path
end

function resManager.getSprite(id)
  local resInfo = g_data.sprite[tonumber(id)]
  assert(resInfo,"cannot found res info by id:"..id)

  local res = ccui.ImageView:create(resInfo.path)
  assert(res,"create ImageView fail:id"..id)
  res.filePath = resInfo.path
  return res
end



local m_CocosAniexportJsonNameList = {}

--创建cocos动画
--如果该动画不频繁使用,建议在退出时,在回调函数里调用如下函数 unLoadCocosAnimFileInfo 释放资源！！！

--参数说明:
--onMovementEventCallFunc(armature , eventType , name)
  -- if ccs.MovementEventType.start == eventType then
  -- elseif ccs.MovementEventType.complete == eventType then
  -- elseif ccs.MovementEventType.loopComplete == eventType then
  -- end

--onFrameEventCallFunc(bone , frameEventName , originFrameIndex , currentFrameIndex)

function LoadCocosAnim(exportJsonName, projectName, onMovementEventCallFunc, onFrameEventCallFunc) 
  ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(exportJsonName)
print("====projectName", projectName)

  local armature = ccs.Armature:create(projectName)
  if onMovementEventCallFunc and type(onMovementEventCallFunc) == "function" then
    armature:getAnimation():setMovementEventCallFunc(onMovementEventCallFunc)
  end
  if onFrameEventCallFunc and type(onFrameEventCallFunc) == "function" then
    armature:getAnimation():setFrameEventCallFunc(onFrameEventCallFunc)
  end

  armature.fileInfoPath = exportJsonName 

  m_CocosAniexportJsonNameList[exportJsonName] = true

  return armature 
end 

--释放动画资源
function unLoadCocosAnimFileInfo(armature) 
  if armature.fileInfoPath then 
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(armature.fileInfoPath) 
    m_CocosAniexportJsonNameList[armature.fileInfoPath] = nil
  end 
end 

--释放所有动画资源(一般在重启游戏时清理)
function removeAllCocosAniFileInfo()
  for k , v in pairs(m_CocosAniexportJsonNameList) do
    unLoadCocosAnimFileInfo(k)
  end
  m_CocosAniexportJsonNameList = {}
end




return resManager
