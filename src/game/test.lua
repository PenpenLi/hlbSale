

local test = {}

test.testAPI = function(uiNode)

  -- 显示资源列表中的图片, 带着色器
  -- local icon = g_resManager.getSprite(1001)
  -- icon:setPosition(cc.p(200, 200))
  -- icon:getVirtualRenderer():setGLProgramState( cc.GLProgramState:getOrCreateWithGLProgramName( g_shader.shaderMode.shader_gray ) )
  -- uiNode:addChild(icon)


--[[ 显示动画 
  local armature
  local function onMovementEventCallFunc(armature , eventType , name)
    if ccs.MovementEventType.complete == eventType or ccs.MovementEventType.loopComplete == eventType then
      print("onMovementEventCallFunc")
      armature:removeFromParent()

      g_resManager.unLoadCocosAnimFileInfo(armature)
    end
  end 

  local function onFrameEventCallFunc(bone , frameEventName , originFrameIndex , currentFrameIndex)
    print("onFrameEventCallFunc")
  end 
  armature = g_resManager.LoadCocosAnim("anime/Effect_ShenWuJianUiText/Effect_ShenWuJianUiText.ExportJson"
                                        , "Effect_ShenWuJianUiText"
                                        , onMovementEventCallFunc
                                        , onFrameEventCallFunc) 
  armature:setPosition(cc.p(300, 300))
  uiNode:addChild(armature)
  armature:getAnimation():play("Effect_TiShengChengGongText") 
--]]

--上浮提示框
  -- g_toast.show("看地方尽快的房东看房", 3)

  -- show(text, title, colorType, callback, btnType, btnStr) 
  -- g_msgBox.show("看地方尽快的房东看房", nil, nil, function(btnType) print("btnType=", btnType)end, 1, {str1 = "ok", str2 = "cancel"})
  -- g_msgBox.showNetError()
  -- g_msgBox.showOffLine()
  -- g_msgBox.showVersionOffLine()

--声音
  -- g_audioManager.playMusic(g_consts.AudioPath.MusicBackground, true)
  -- g_audioManager.playEffect(g_consts.AudioPath.EffectConfirm)



end 


return test 
