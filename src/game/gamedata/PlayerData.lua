
local PlayerData = {}
setmetatable(PlayerData,{__index = _G})
setfenv(1,PlayerData)

local m_baseData = nil



function setData(data)
    m_baseData = data
end


--得到基本信息,只可使用不可修改
function getData()
    --test +++++++++++++++++++++++++++++++++++++>
    m_baseData = {id = 1234}



    if nil == m_baseData then
        RequestData()
    end
    return m_baseData
end

--与玩家基本信息关联的模块,显示更新可以放这里
function notifyUpdateShow()

end

--请求数据
function requestData()
    local ret = false
    local function onRecv(result, msgData)
        if (result == true) then
            ret = true
            setData(msgData.Player)
            notifyUpdateShow()
        end
    end
    g_http.postData("data/index", {name = {"Player"}}, onRecv)
    return ret
end

--异步请求数据
function requestDataAsync()
    local function onRecv(result, msgData)
        if (result == true) then
            setData(msgData.Player)
            notifyUpdateShow()
        end
    end
    g_http.postData("data/index", {name = {"Player",}}, onRecv, true)
end


return PlayerData
