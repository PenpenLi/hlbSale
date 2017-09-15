

local HttpLua = {}
setmetatable(HttpLua,{__index = _G})
setfenv(1,HttpLua)

local NET_DEBUG = true

--[[ 
example:

    local tbl = {
        ["name"] = "tt",
        ["aa"] = {["cc"]="bb", ["kk"]=1}
      }
    local function test2(result, data)
      print("result:", result) 
      dump(data)     
    end 
    HttpLua.postData("/dev/testPost/", tbl, test2)
--]]


function HttpLua.getMd5Suffix()
    return "md5_suffix"
end 

function HttpLua.getUUID()
    local uuid = "eeee"
    local hash = GameUtil:getMD5String(uuid..HttpLua.getMd5Suffix())
    
    return uuid, hash 

    -- HttpLua._UUID = g_account.getUserPlatformUid().."_"..g_account.getChannel()
    -- HttpLua._UUIDMd5 = PSDeviceInfo:getMD5String(HttpLua._UUID)
    -- return HttpLua._UUID, HttpLua._UUIDMd5
end 

function HttpLua.handleEventCode(code)
    print("handleEventCode: ", code)
    if code == 9000 then --与服务器版本号不一致
        g_msgBox.showVersionOffLine() 
    elseif code == 9001 then --被挤下线
        g_msgBox.showOffLine(g_tr("msgBox_offLine")) 
    elseif code == 9002 then --被封号
        g_msgBox.showDisableUser()
    elseif code == 9003 then --服务器维护中,非授权的ip登入游戏
        g_msgBox.showOffLine(g_tr("serverMaintainTip")) 
    elseif code == 9004 then --时间未同步
    elseif code == 9005 then --创建玩家失败
    elseif code == 9006 then --无效的时间戳(可能为恶意重发)
       g_clock.ntpServerTime()     
    else --基本逻辑错误

    end 
end 

function HttpLua.printLog(logType, method, recvData, useAsync)
    if not NET_DEBUG then return end 

    if logType == "net_error" then 
        print(string.format("%s%s\"%s\"", (useAsync and "异步" or "同步"), "收到 URL = ", method))
        print("网络错误: data = " .. recvData)

    elseif logType == "data_error" then 
        print(string.format("%s%s\"%s\"", (useAsync and "异步" or "同步"), "收到 URL = ", method))
        print("服务器数据错误")
    else 
        print(string.format("%s%s\"%s\"", (useAsync and "异步" or "同步"), "收到 URL = ", method))
        print(recvData)
    end 
end 

--参数说明
--method: url中的模块方法; 
--jsonTbl:发送给服务器的json数据(lua table 格式)
--callback: 用户回调, 返回json数据(lua table 格式)
--useAsync: 是否异步
function HttpLua.postData(method, jsonTbl, callback , useAsync)

    if g_msgBox.getCurBoxFlag() > 0 then return end --如果当前弹框提示下线,异地登陆,封号等情况则直接返回

    local host = g_account.getHttpHost()
    local url 
    if string.sub(method, 1, 1) ~= "/" then 
        url = host .. "/" .. method 
    else 
        url = host .. method 
    end 
    print("@@@@@ host =", host)
    
    jsonTbl = jsonTbl or {}
    jsonTbl.uuid, jsonTbl.hashCode = HttpLua.getUUID()    --与平台相关
    jsonTbl.game_version = g_gameConfig.serverVersion 
    jsonTbl.login_hashcode = g_account.getLoginHashCode() --登录过程checkPlayer阶段下发
    jsonTbl.timestamp = g_clock.getCurServerTime() 
    jsonTbl.timeCollated = g_clock.isTimeCollated()       --时间同步过后才有效
    
    local para = jsonTbl and "json="..cjson.encode(jsonTbl) or ""
    
    local function onRecv(result, data, performCode, responseCode)
        if result == false then --网络错误           
            printLog("net_error", method, data, useAsync)
            if callback then
                callback(false, nil)
            end

        elseif data == nil or data == "" then --服务器数据错误 
            printLog("data_error", method, data, useAsync)
            if callback then
                callback(false, nil)
            end
        else
            printLog("success", method, data, useAsync)
            local dataTable = cjson.decode( data )                        
            -- if dataTable.steps then 
            --     g_guideData.setCurrentServerStepId(dataTable.steps.step)
            --     g_guideData.setSavedOutOfOrderStepIds(dataTable.steps.step_set)
            -- end
            
            if tonumber(dataTable.code) > 0 then 
                result = false 
                HttpLua.handleEventCode(tonumber(dataTable.code))
            else 
                --没有错误
                if dataTable.basic then
                    g_requestManager.updateBasicData(dataTable.basic)
                end
            end 

            if callback then
                callback(result , dataTable.data)
            end 
        end
    end

    if NET_DEBUG then
        print(string.format("%s%s\"%s\"", (useAsync and "异步" or "同步") , "发送URL = ", method))
        print(para)
    end 

    --对参数进行MD5 hash,防止被恶意篡改, 服务器端一旦发现url参数被篡改则直接忽略该次请求.
    para = para .. "@" .. GameUtil:getMD5String(para..HttpLua.getMd5Suffix())
    HttpNet:getInstance():post(url, para, string.len(para), onRecv, 12, 12, (useAsync and true or false), true) 
end 

return HttpLua 
