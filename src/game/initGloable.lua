
cc.exports.g_display = require("cocos.framework.display")

--配置数据
cc.exports.g_data = require ("data.initData")
--多语言
cc.exports.g_tr = require("game.localization.localization").translate 
--常量/数据结构定义
cc.exports.g_consts = require("game.public.consts")
--view
cc.exports.g_viewManager = require("game.manager.viewManager") 
--网络请求
cc.exports.g_requestManager = require("game.manager.requestManager")
--资源
cc.exports.g_resManager = require("game.manager.resManager")
--游戏控制
cc.exports.g_gameManager = require("game.manager.gameManager")
--声音
cc.exports.g_audioManager = require("game.manager.audioManager") 

--公共工具
cc.exports.g_gameUtil = require("game.public.gameUtil")
--事件派发器
cc.exports.g_eventDispatch = require("game.public.eventDispatch")
--网络
cc.exports.g_http = require("network.httpNet")

cc.exports.g_tcp = require("network.tcpNet")

--提示框
cc.exports.g_toast = require("game.msgbox.toast")
cc.exports.g_msgBox = require("game.msgbox.msgBox")

--时间
cc.exports.g_clock = require("game.public.clock") 

--着色器
cc.exports.g_shader = require("game.public.shader") 
