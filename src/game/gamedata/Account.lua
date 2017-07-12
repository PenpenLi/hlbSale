
local Account = {}
setmetatable(Account,{__index = _G})
setfenv(1,Account)








return Account 