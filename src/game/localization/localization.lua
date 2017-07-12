

local localization = {}
local i18n = require("game.localization.i18n.init")


local langConfig = require("game.localization.langConfig") 
localization.languagelist = langConfig.getLanguageList()
localization.countryKey = langConfig.getCountryCode()
localization.language = localization.languagelist[localization.countryKey] or "zhcn" 

-- load language file
i18n.setLocale(localization.language)

local i18nLang = require("game.localization."..localization.language) --自定义的多语言

function localization.loadDataLang(config) --数据表的多语言
  for key, var in pairs(config) do
    local targetKey = tostring(var.id)
    assert(i18nLang[targetKey] == nil,"conflicted key name:"..targetKey)
    i18nLang[targetKey] = var.desc
  end
end

function localization.init()
  local i18nData = {}
  i18nData[localization.language] = i18nLang
  i18n.load(i18nData)
end

function localization.originalStr(key)
  return i18nLang[tostring(key)]
end

--返回指定 id 的语言字串
function localization.translate(key, data)
  local word = i18n(tostring(key), data)
  if nil == word then
    word = key
    word = string.gsub(word, "%%", " ") 
    printf("Can not found word for key:%s",key)
  end
  return word
end


return localization 
