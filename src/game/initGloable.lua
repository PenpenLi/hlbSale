
cc.exports.g_display = require("cocos.framework.display")

--配置数据
cc.exports.g_data = require ("data.InitData")
--多语言
cc.exports.g_tr = require("game.localization.localization").translate 
--常量/数据结构定义
cc.exports.g_consts = require("game.public.Consts")
--view
cc.exports.g_viewManager = require("game.manager.ViewManager") 
--网络请求
cc.exports.g_requestManager = require("game.manager.RequestManager")
--资源
cc.exports.g_resManager = require("game.manager.ResManager")
--游戏控制
cc.exports.g_gameManager = require("game.manager.GameManager")
--声音
cc.exports.g_audioManager = require("game.manager.AudioManager") 

--公共工具
cc.exports.g_gameUtil = require("game.public.GameUtil")
--事件派发器
cc.exports.g_eventDispatch = require("game.public.EventDispatch")
--网络
cc.exports.g_http = require("network.HttpNet")

cc.exports.g_tcp = require("network.TcpNet")

--提示框
cc.exports.g_toast = require("game.msgbox.Toast")
cc.exports.g_msgBox = require("game.msgbox.MsgBox")

--时间
cc.exports.g_clock = require("game.public.Clock") 

--着色器
cc.exports.g_shader = require("game.public.Shader") 
