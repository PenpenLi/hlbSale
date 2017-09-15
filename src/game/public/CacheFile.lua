
--本地的缓存文件,用于记录用户的设置信息

local CacheFile = {}
setmetatable(CacheFile,{__index = _G})
setfenv(1,CacheFile)

local m_cachePath = "user_config.json" 

local m_config = { --初始配置信息
  sound_music = 1,
  sound_sound = 1,

}

function getConfig()
  return m_config 
end 

function getValue(key)
  return m_config[key]
end 

function setValue(key, val)
  m_config[key] = val 
end 

function saveToFile()
  cc.FileUtils:getInstance():writeStringToFile(cjson.encode(m_config), m_cachePath)
end 

--如果存在缓存文件则加载,否则使用默认设置
function loadCache()
  local _fileUtils = cc.FileUtils:getInstance() 
  if _fileUtils:isFileExist(m_cachePath) then 
    m_config = cjson.decode(_fileUtils:getStringFromFile(m_cachePath))
  end 
end 

loadCache()

return CacheFile
