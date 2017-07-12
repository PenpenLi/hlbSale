local MsgBox = {}
setmetatable(MsgBox,{__index = _G})
setfenv(1,MsgBox)


local function _create(text, title, colorType, callback, btnType, btnStr)
  local widget = g_gameUtil.loadCocosUI("csb/msg_box/msg_box_popup.csb", 5)
  local scale_node =  widget:getChildByName("scale_node") 
  scale_node:getChildByName("Text_1"):setString(title or g_tr("MsgBox_system"))

  local scale_node = widget:getChildByName("scale_node")
  uiText = scale_node:getChildByName("Text_2")
  
  local color
  if colorType == 1 then
    color = cc.c4b(0,255,0,255)
  elseif colorType == 2 then
    color = cc.c4b(255,255,0,255)
  elseif colorType == 3 then
    color = cc.c4b(255,0,0,255)
  else
    color = cc.c4b(255,255,255,255)
  end
  uiText:setString(text or "")
  uiText:setTextColor(color)
  
  
  

  local open_animation_completed = false
  
  local function onButtonOK(sender, eventType)
    if open_animation_completed then
      g_audioManage.playEffect(g_consts.AudioPath.EffectConfirm)
      widget:removeFromParent()
      if(callback and type(callback)=="function")then
        callback(0)
      end
    end
  end
  
  local function onButtonCancle(sender, eventType)
    if open_animation_completed then
      g_audioManage.playEffect(g_consts.AudioPath.EffectCancel)
      widget:removeFromParent()
      if(callback and type(callback)=="function")then
        callback(1)
      end
    end
  end
  
  local btn1 = scale_node:getChildByName("Button_1")
  local btn2 = scale_node:getChildByName("Button_2")

  btn1:addClickEventListener(onButtonOK)
  btn2:addClickEventListener(onButtonCancle)
  if nil == btnType or 0 == btnType then --只有一个按钮
    btn1:setPositionX(0)
    btn2:setVisible(false) 
  end 
  btn1:setTitleText(g_tr("MsgBox_ok"))
  btn2:setTitleText(g_tr("MsgBox_cancle"))

  if btnStr and type(btnStr)=="table" then
    if btnStr.str1 then 
      btn1:setTitleText(btnStr.str1)
    end 
    if btnStr.str2 then 
      btn2:setTitleText(btnStr.str2)
    end     
  end 

  local origin_scale = scale_node:getScale()
  scale_node:setScale(origin_scale * 0.5)
  scale_node:runAction(cc.Sequence:create(cc.EaseBackOut:create(cc.ScaleTo:create(0.35, origin_scale)), cc.CallFunc:create(function() open_animation_completed = true end)))
  
  return widget
end


--显示一个提示框或二次确认框
--参数： text 显示文本
--参数： title 标题文本 ，不传为默认标题
--参数： colorType 显示类型 ， 不传为默认类型(白色), 1为成功类型(绿色) ,2为警告(黄色) ,3为错误(红色)
--参数:  callback 回调监听 ， 可以不传 , 回调形参是一个event (0是点击了确定,1是点击了取消) --事件类型必须判断是否是自己想要的,今后可能扩展234567....
--参数： btnType 按钮类型 ， 不传或者传0都为默认只出现一个确认按钮,传1为确认和取消两个按钮
--参数:  btnStr 修改数据 , {str1 = "确定按钮文字" , str2 = "取消按钮文字"}
function show(text, title, colorType, callback, btnType, btnStr)
  g_viewManager.addNodeForMsgBox(_create(text, title, colorType, callback, btnType, btnStr))
end


--顶层弹窗只存在一个,并且是在最高层,超过新手引导
local m_isTopBoxExist = false
function showTop(str, callback)

  if m_isTopBoxExist == true then return end 
  
  local function callbackFunc(event)
    if event == 0 then 
      if callback then 
        callback()
      end 
    end
  end

  local function nodeEventHandler(eventType)
    if eventType == "enter" then
      m_isTopBoxExist = true
    elseif eventType == "exit" then
      m_isTopBoxExist = false
    end 
  end
  local node = _create(str, nil, nil, callbackFunc)
  node:registerScriptHandler(nodeEventHandler)  
  g_viewManager.addNodeForNetError(node)
end

--网络状况不好的专用弹出窗口
function showNetError()
  showTop(g_tr("MsgBox_netError"))
end 

--网络请求数据错误的专用弹出窗口
function showNetDataError()
  showTop(g_tr("MsgBox_netDataError"))
end 

--被挤下线专用弹出窗口
function showOffLine()
  showTop(g_tr("MsgBox_offLine"), function() g_gameManager.reStartGame() end) 
end 

--强制下线更新弹出窗口
function showVersionOffLine()
  httpNet:getInstance():discardAllPost() 
  showTop(g_tr("MsgBox_versionOffLine"), function() g_gameManager.reStartGame() end) 
end 

--被封号以后强制下线弹出窗口
function showDisableUser()
  httpNet:getInstance():discardAllPost() 
  showTop(g_tr("MsgBox_disableUser"), function() g_gameManager.reStartGame() end) 
end 

return MsgBox
