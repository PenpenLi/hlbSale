
local ViewManager = {}
setmetatable(ViewManager,{__index = _G})
setfenv(1,ViewManager)

local mLayerRoot 
local layerEnum = {
                    Map      = 1, --地图层
                    UI       = 2, --UI层
                    MsgBox   = 3, --pop弹框 
                    Effect   = 4, --特效层
                    Guild    = 5, --新手引导
                    NetError = 6, --网络断开
                  }
local m_layerObjs = {}
local m_sceneType

--进入新场景时默认显示的layer
local function initSceneLayer(sceneType) 
  if sceneType == g_consts.SceneType.login then 
    addNodeForUI(require("game.views.login.LoginView").new()) 
  elseif sceneType == g_consts.SceneType.loading then 
    addNodeForUI(require("game.views.loading.LoadingView").new()) 
  elseif sceneType == g_consts.SceneType.game then 
    addNodeForUI(require("game.views.home.HomeView").new()) 
  end 
end 

--切换场景
function setScene(sceneType)
  print("setScene", sceneType)
  m_sceneType = sceneType

  if mLayerRoot then 
    mLayerRoot:removeFromParent()
  end

  local newScene = cc.Scene:create()

  mLayerRoot = cc.Layer:create()
  mLayerRoot:setIgnoreAnchorPointForPosition(false)
  mLayerRoot:setAnchorPoint(cc.p(0.5,0.5))
  mLayerRoot:setPosition(display.center)  
  newScene:addChild(mLayerRoot)

  local node 
  for k, zorder in pairs(layerEnum) do 
    node = cc.Node:create()
    node:setIgnoreAnchorPointForPosition(false)
    node:setAnchorPoint(cc.p(0.5,0.5)) 
    node:setPosition(display.center)
    node:setContentSize(display.size)  
    mLayerRoot:addChild(node, zorder)
    m_layerObjs[zorder] = node 
  end 

  initSceneLayer(sceneType)

  local director = cc.Director:getInstance()
  if director:getRunningScene() then 
    director:replaceScene(newScene)
  else
    director:runWithScene(newScene)
  end 
end 

function addNodeForMap(node)
  if node then
    m_layerObjs[layerEnum.Map]:addChild(node)
  end
end

function addNodeForUI(node) 
  if node then 
    m_layerObjs[layerEnum.UI]:addChild(node)
  end
end

function addNodeForMsgBox(node) 
  if node then
    m_layerObjs[layerEnum.MsgBox]:addChild(node)
  end
end 

function addNodeForNetError(node) 
  if node then
    m_layerObjs[layerEnum.NetError]:addChild(node)
  end
end 

function addNodeForEffect(node) 
  if node then
    m_layerObjs[layerEnum.Effect]:addChild(node)
  end
end 

function addNodeForGuild(node) 
  if node then
    m_layerObjs[layerEnum.Guild]:addChild(node)
  end
end

function getCurSceneType()
  return m_sceneType 
end 

return ViewManager