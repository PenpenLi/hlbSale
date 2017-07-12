
--加载数据和多语言数据
local allConfig = {}
setmetatable(allConfig,{__index = _G})
setfenv(1,allConfig)

local localization = require("game.localization.localization")
local gobalDefine = require("data.data._GGobalDefine")
local list = gobalDefine.TableList

for key, var in pairs(list) do
  local k = string.lower(var)

  local config = require("data.data."..var)

  --多语言分开加载 
  local isLanguageData = false
  for l_key, lang in pairs(localization.languagelist) do
    if lang == k then
      isLanguageData = true
      if k == localization.language then
        localization.loadDataLang(config) --加载数据表多语言, 客户自定义的多语言已在localization.lua头部自动加载
        localization.init() --初始化i18n 
        break
      end
    end
  end
  
  if not isLanguageData then 
    allConfig[k] = {}
    for key, var in pairs(config) do
      assert(var.id,"init data error:invaild id @allConfig."..k)
      allConfig[k][var.id] = var
    end
  end
end


return allConfig
