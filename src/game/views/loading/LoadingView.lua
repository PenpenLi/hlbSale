
--申请数据,加载资源过程,加载完毕进入首页时释放不必要的资源(比如login,loading资源)
local LoadingView = class("LoadingView",require("game.views.base.BaseLayer")) 
local LoadingFunc = require("game.views.loading.LoadingFunc")

local count
local nextPercent 
local viewObj 
local m_timer 

function LoadingView:ctor()
  LoadingView.super.ctor(self)

end 

function LoadingView:onEnter() 
  viewObj = self 
  local layer = g_gameTool.loadCocosUI("csb/loading/loading.csb", 5)
  if layer then 
    self.loadingBar = layer:getChildByName("scale_node"):getChildByName("LoadingBar_1") 
    self.loadingBar:setPercent(0)
    self:addChild(layer)
  end 

  count = 0 
  nextPercent = 5 
  m_timer = self:schedule(handler(self, self.update), 0) 

  LoadingFunc.startLoading(handler(self, self.updatePercent))
end 

function LoadingView:onExit() 
  viewObj = nil 
  if m_timer then 
    self:unschedule(m_timer)
    m_timer = nil 
  end 
  self:unscheduleUpdate() 
end 

function LoadingView:updatePercent(result, percent) 
  if nil == viewObj then return end 

  print("updatePercent:", percent)
  if result then 
    nextPercent = percent 
  else 
    g_msgBox.show(g_tr("loadingFailTips"), nil, nil, function(eventType) 
        if eventType == 0 then --重试
          LoadingFunc.resumeLoading()
        end 
      end, 
      1, {str1 = g_tr("msgBox_retry")})
  end 
end 


--逐步过渡到目标百分比
function LoadingView:update() 
  if nil == viewObj then return end 

  if count < nextPercent and self.loadingBar then 
    count = count + 1 
    self.loadingBar:setPercent(count)

    if count == 100 then 
      if m_timer then 
        self:unschedule(m_timer)
        m_timer = nil 
      end 
      g_viewManager.setScene(g_consts.SceneType.game) 
    end 
  end 
end 




return LoadingView 
