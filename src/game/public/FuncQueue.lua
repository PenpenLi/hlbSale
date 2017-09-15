
--函数队列执行,队列数组如下形式:
-- local jobQueue = {
--   {func = requestCombo, weight = 10, isASync = false},
--   {func = requestDataIndex, weight = 30, isASync = false},
-- }
--注: 
--同步执行的队列(如网络请求),当前请求得到正确响应后,才能执行下一请求;同步事件注意先后顺序!!!
--异步执行的队列(如资源异步加载), 可直接执行;
--参数: func:执行的动作, weight:所占权重, isASync:是否异步执行; status:0 初始 1:正在执行 2:已完成
--根据需要排列任务的先后顺序和是否可异步执行; 当前每次同时执行1个同步和3个异步任务;
--函数中最好不要做任何复杂的耗时计算操作；

--执行步骤: 1)外部调用 startProcess() 
--          2)当某一个任务处理完后需要调用endOneSyncExec()来更新状态;
--          3)如果发生错误, 外部调用 stopProcess();
--          4)处理完错误,外部调用 resumeProcess() 继续执行;

local FuncQueue = {}
setmetatable(FuncQueue,{__index = _G})
setfenv(1, FuncQueue)

local m_jobQueue
local m_doneWeight  --已完成任务的累计权重
local m_totalWeight --所有任务的累计权重
local m_hasError    --执行过程中是否有错误
local m_callback 

--开始执行任务队列:参数 queueList 任务队列,格式如上面注解; updateCallback:包含2个参数 (result, percent)
function startProcess(queueList, updateCallback)
  m_jobQueue = queueList 
  m_callback = updateCallback 

  --初始化
  m_doneWeight = 0 
  m_totalWeight = 0 
  m_hasError = false 
  for k, v in pairs(m_jobQueue) do 
    m_totalWeight = m_totalWeight + v.weight 
    m_jobQueue[k].status = 0 
  end 

  doOneJob() 
end 

function resumeProcess()
  m_hasError = false 
  doOneJob()
end 

function stopProcess()
  for k, v in pairs(m_jobQueue) do 
    if v.status == 1 then 
      m_jobQueue[k].status = 0 
    end 
  end 
end 

--执行一个同步事件,以及3个异步事件
function doOneJob()
  if not m_hasError then 

    --计算当前正在执行的任务数
    local syncNum = 0 
    local asyncNum = 0 
    for k, v in pairs(m_jobQueue) do 
      if v.status == 1 then 
        if v.isASync == false then 
          syncNum = syncNum + 1 
        else 
          asyncNum = asyncNum + 1 
        end 
      end 
    end 

    --执行1个同步和1个异步任务
    for k, v in pairs(m_jobQueue) do 
      if v.isASync == false and v.status == 0 and syncNum < 1 then 
        syncNum = syncNum + 1 
        m_jobQueue[k].status = 1 
        if v.func() == false then 
          m_hasError = true 
          m_jobQueue[k].status = 0 
          break 
        end 
      end 

      if v.isASync and v.status == 0 and asyncNum < 3 then 
        m_jobQueue[k].status = 1 
        asyncNum = asyncNum + 1 
        if v.func() == false then 
          m_hasError = true 
          m_jobQueue[k].status = 0 
          break 
        end       
      end 
    end 

    --队列已执行完
    if syncNum == 0 and asyncNum == 0 then 
      if m_callback then 
        m_callback(true, 100) 
      end 
    end 
  end 

  if m_hasError then 
    if m_callback then 
      m_callback(false, nil) 
    end 
  end 
end 

--(供外部调用)当执行完一个同步任务时,更新状态,以便触发下一同步任务
function endOneSyncExec(func) 
  local addWeight = 0 
  for k, v in pairs(m_jobQueue) do 
    if v.func == func then 
      addWeight = v.weight 
      m_jobQueue[k].status = 2 
      break 
    end 
  end 
  m_doneWeight = m_doneWeight + addWeight
  --更新UI
  local nextPercent = math.ceil(100 * m_doneWeight/m_totalWeight)
  if m_callback then 
    m_callback(true, nextPercent)
  end 
  
  doOneJob()
end 

return FuncQueue
