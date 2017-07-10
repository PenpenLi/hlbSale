
local account = {}
setmetatable(account,{__index = _G})
setfenv(1,account)








return account 