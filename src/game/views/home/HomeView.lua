
local HomeView = class("HomeView",require("game.views.base.BaseLayer"))

function HomeView:ctor()
  HomeView.super.ctor(self)
end 

function HomeView:onEnter()
  -- local layer = cc.CSLoader:createNode("csb/home/home.csb")
  
  local layer = g_gameTool.loadCocosUI("csb/home/home.csb", 5)
  if layer then 

    local btn = layer:getChildByName("scale_node"):getChildByName("Button_1")
    local btn2 = layer:getChildByName("scale_node"):getChildByName("Button_2")
    btn:addClickEventListener(function() require("game.test").testAPI(self) end)
    btn2:addClickEventListener(function() require("game.test").testOther(self) end)
    self:addChild(layer)
  end 
end 

function HomeView:onExit() 
end 




return HomeView 
