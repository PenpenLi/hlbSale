local BusyTip = {}
setmetatable(BusyTip,{__index = _G})
setfenv(1,BusyTip)

local m_Tip_1 = nil

function show_1()
	if m_Tip_1 then
		m_Tip_1:removeFromParent(false)
	else

		m_Tip_1 = cc.LayerColor:create(cc.c4b(0,0,0,128))
		m_Tip_1:retain()
		local loadingImage = cc.Sprite:create("res/client/common/loading.png")
		loadingImage:setPosition(g_display.center)
		loadingImage:runAction(cc.RepeatForever:create(cc.RotateBy:create(0.8, 180)))
		m_Tip_1:addChild(loadingImage)
		local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
		local function onTouchBegan(touch, event)
			return true
		end
		local function onTouchEnded(touch, event)
		end 
		local touchListener = cc.EventListenerTouchOneByOne:create()
		touchListener:setSwallowTouches(true)
		touchListener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
		touchListener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
		eventDispatcher:addEventListenerWithSceneGraphPriority(touchListener,m_Tip_1)
	end
	g_viewManager.addNodeForMsgBox(m_Tip_1)
end


function hide_1()
	if m_Tip_1 then
		m_Tip_1:removeFromParent()
		m_Tip_1:release()
		m_Tip_1 = nil
	end
end


return BusyTip