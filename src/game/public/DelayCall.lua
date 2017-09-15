
--精确延时处理
--当游戏主循环暂停后再恢复轮训时保证时间准确性;
--适用情况:
--1)适用于精确延时处理;
--2)多个延时处理;
-- 注: 0.2秒轮询一次, 因此一般情况下尽量少用,当延时较大如超过10秒时禁止使用) 

local DelayCall = {}
setmetatable(DelayCall,{__index = _G})
setfenv(1,DelayCall)



local m_CocosList = {}
local m_timer 
local m_lastTime = os.time()


--加入以cocos时间步长为基准计算的队列
--callback 回调方法
--waitTime 等待时间 sec
function addCocosList( callback , waitTime )
	if callback and type(callback) == "function" then	
		table.insert(m_CocosList, { func = callback , time = (waitTime or 0) })
		startLoop()
	end
end

--移除指定回调对应的定时器
function removeCocosList(callback) 
	for k , v in ipairs(m_CocosList) do 
		if v.func == callback then 
			table.remove(m_CocosList, k) 
			break 
		end 
	end 
	if #m_CocosList == 0 then 
		stopLoop()
	end 
end 


--循环更新
function updateLoop()

	local willCallList = {}
	
	local currentTime = socket.gettime()
	local real_dt = math.max(0,currentTime - m_lastTime)
	m_lastTime = currentTime
	
	do
		local removeCount = 0
		local totalCount = #m_CocosList
		for i = 1 , totalCount do
			local v = m_CocosList[i - removeCount]
			v.time = v.time - real_dt
			if v.time <= 0 then
				willCallList[(#willCallList) + 1] = v.func
				table.remove(m_CocosList, i - removeCount)
				removeCount = removeCount + 1
			end
		end
	end

	if #m_CocosList == 0 then 
		stopLoop()
	end 

	--触发
	for k , v in ipairs(willCallList) do
		v()
	end 
end

function startLoop()
  stopLoop()
  m_timer = cc.Director:getInstance():getScheduler():scheduleScriptFunc(updateLoop, 0.2, false) 
end 

function stopLoop()
  if m_timer then 
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(m_timer) 
    m_timer = nil 
  end   
end


return DelayCall