
local GameTool = {}
setmetatable(GameTool,{__index = _G})
setfenv(1, GameTool)




--加载cocosUI的
--参数 ：csb名字 , UI基准位置（打印的排版排序1-9）。位置可以传空，那就需要自己设置了
--函数中主要设置了基准 坐标 锚点 适配缩放比例
function loadCocosUI(filename, place)
  local widget = cc.CSLoader:createNode(filename)
  if widget and place then
    if place ==1 then
      widget:setAnchorPoint(cc.p(0.0,1.0))
      widget:setPosition(display.left_top)
    elseif place==2 then
      widget:setAnchorPoint(cc.p(0.5,1.0))
      widget:setPosition(display.top_center)
    elseif place==3 then
      widget:setAnchorPoint(cc.p(1.0,1.0))
      widget:setPosition(display.right_top)
    elseif place==4 then
      widget:setAnchorPoint(cc.p(0.0,0.5))
      widget:setPosition(display.left_center)
    elseif place==5 then
      widget:setAnchorPoint(cc.p(0.5,0.5))
      widget:setPosition(display.center)
    elseif place==6 then
      widget:setAnchorPoint(cc.p(1.0,0.5))
      widget:setPosition(display.right_center)
    elseif place==7 then
      widget:setAnchorPoint(cc.p(0.0,0.0))
      widget:setPosition(display.left_bottom)
    elseif place==8 then
      widget:setAnchorPoint(cc.p(0.5,0.0))
      widget:setPosition(display.bottom_center)
    elseif place==9 then
      widget:setAnchorPoint(cc.p(1.0,0.0))
      widget:setPosition(display.right_bottom)
    end 
  end 

  if widget then 
    local scale_node = widget:getChildByName("scale_node")
    if scale_node then 
      scale_node:setScale(g_display.scale)
    else 
      assert(false, "widget has no scale node !!! -->"..filename)
    end 
  end 

  return widget
end


--执行java函数(如果java函数不存在,不会导致程序崩溃) onResult(data), 其中参数data： "true", "false"
--calssName:java类名(如 org.cocos2dx.lua.AppActivity 或 org/cocos2dx/lua/AppActivity)
--funcName：java类成员函数
function execJavaFunc(calssName, funcName, onResult)
  local params = {string.gsub(calssName,'/','.'), funcName, onResult}
  local arg = "(Ljava/lang/String;Ljava/lang/String;I)V"
  local luaj = require "cocos.cocos2d.luaj"
  luaj.callStaticMethod("org/cocos2dx/lua/AppActivity", "isFuncExist", params, arg)
end 



return GameTool 
