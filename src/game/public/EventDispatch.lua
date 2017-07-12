local EventDispatch = {}
setmetatable(EventDispatch,{__index = _G})
setfenv(1,EventDispatch)

--用户事件监听派发

local eventHandlers = {}

--注册事件回调
function addEventHandler(event, handler, target)
  print("event, handler", event, handler, target)
  if nil == eventHandlers[event] then 
    eventHandlers[event] = {}
  end 

  for k, v in pairs(eventHandlers[event]) do 
    if v.obj == target and v.func == handler then 
      return 
    end 
  end 

  table.insert(eventHandlers[event], {obj = target, func = handler})
end 


function removeEventHandler(event, target) 
  if nil == eventHandlers[event] then return end 

  for k, v in pairs(eventHandlers[event]) do 
    if v.obj == target then 
      eventHandlers[event][k] = nil 
      break 
    end 
  end 
end 

--删除该目标所有监听器 
function removeAllEventHandlers(target) 
  for i, objFunc in pairs(eventHandlers) do 
    for k, v in pairs(objFunc) do 
      if v.obj == target then 
        eventHandlers[i][k] = nil 
      end
    end 
  end   
end 

function sendEvent(event, data) 
  if nil == eventHandlers[event] then return end 

  for k, v in pairs(eventHandlers[event]) do 
    if v.func then 
      v.func(v.obj, data)
    end 
  end 
end 

return EventDispatch
