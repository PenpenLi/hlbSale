
local audioManager = {}
setmetatable(audioManager,{__index = _G})
setfenv(1,audioManager)


local mOpenMusic = true
local mOpenEffect = true
local mRecordName = ""
local mRecordIsLoop = true


--预加载背景音乐
function preloadMusic(filename)
	if (filename==nil or filename=="") then
		return
	end
	cc.SimpleAudioEngine:getInstance():preloadMusic(cc.FileUtils:getInstance():fullPathForFilename(filename))
end

--播放背景音乐
function playMusic(filename, isLoop)
	if (not mOpenMusic) or nil == filename or filename == "" then
		return
	end
	
	mRecordName = filename
	mRecordIsLoop = (isLoop == true)
	cc.SimpleAudioEngine:getInstance():playMusic(cc.FileUtils:getInstance():fullPathForFilename(filename), mRecordIsLoop)
end 

--停止背景音乐:isReleaseData 是否释放资源
function stopMusic(isReleaseData) 
	mRecordName = ""
	mRecordIsLoop = true
	local releaseDataValue = (isReleaseData == true)
	cc.SimpleAudioEngine:getInstance():stopMusic(releaseDataValue)
end

--预加载特效音乐
function preloadEffect(filename)
	if nil == filename or filename == "" then
		return
	end
	cc.SimpleAudioEngine:getInstance():preloadEffect(cc.FileUtils:getInstance():fullPathForFilename(filename))
end

--卸载特效音乐
function unloadEffect(filename)
	if nil == filename or filename == "" then
		return
	end
	cc.SimpleAudioEngine:getInstance():unloadEffect(cc.FileUtils:getInstance():fullPathForFilename(filename))
end

--播放特效音乐
function playEffect(filename,isLoop)
	if (not mOpenEffect) or nil == filename or filename == "" then
		return
	end 
	local loopValue = (isLoop == true)
	return cc.SimpleAudioEngine:getInstance():playEffect(cc.FileUtils:getInstance():fullPathForFilename(filename),loopValue)
end

--暂停特效音乐
function pauseEffect(handle)
	cc.SimpleAudioEngine:getInstance():pauseEffect(handle)
end

--恢复特效音乐
function resumeEffect(handle)
	cc.SimpleAudioEngine:getInstance():resumeEffect(handle)
end

--停止特效音乐
function stopEffect(handle)
	cc.SimpleAudioEngine:getInstance():stopEffect(handle)
end

--停止所有特效音乐
function stopAllEffects()
	cc.SimpleAudioEngine:getInstance():stopAllEffects()
end

--设置背景音乐音量0.0 ~ 1.0
function setMusicVolume(volume)
	cc.SimpleAudioEngine:getInstance():setMusicVolume(volume)
end

--设置特效音乐音量0.0 ~ 1.0
function setEffectsVolume(volume)
	cc.SimpleAudioEngine:getInstance():setEffectsVolume(volume)
end

--取得背景音乐音量
function getMusicVolume()
	return cc.SimpleAudioEngine:getInstance():getMusicVolume()
end

--取得特效音乐音量
function getEffectsVolume()
	return cc.SimpleAudioEngine:getInstance():getEffectsVolume()
end

--暂停背景音乐
function pauseMusic()
	cc.SimpleAudioEngine:getInstance():pauseMusic()
end

--恢复背景音乐
function resumeMusic()
	cc.SimpleAudioEngine:getInstance():resumeMusic()
end

--暂停所有特效音乐
function pauseAllEffects()
	cc.SimpleAudioEngine:getInstance():pauseAllEffects()
end

--恢复所有特效音乐
function resumeAllEffects(handle)
	cc.SimpleAudioEngine:getInstance():resumeAllEffects()
end

--回放背景音乐
function rewindMusic()
	cc.SimpleAudioEngine:getInstance():rewindMusic()
end

--是否正播放背景音乐
function isMusicPlaying()
	return cc.SimpleAudioEngine:getInstance():isMusicPlaying()
end

--是否会播放背景音乐
function willPlayMusic()
	return cc.SimpleAudioEngine:getInstance():willPlayMusic()
end


--开启背景音乐
function openMusic()
	if not mOpenMusic then
		mOpenMusic = true
		if mRecordName ~= "" then
			playMusic(mRecordName, mRecordIsLoop)
		end	
	end
end

--关闭背景音乐
function closeMusic()
	mOpenMusic = false
	if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then
		cc.SimpleAudioEngine:getInstance():stopMusic(true)
	else
		cc.SimpleAudioEngine:getInstance():stopMusic(false)
	end
end

--是否开启了背景音乐
function isOpenMusic()
	return mOpenMusic
end


--开启特效音乐
function openEffects()
	mOpenEffect = true
end

--关闭特效音乐
function closeEffects()
	mOpenEffect = false
	cc.SimpleAudioEngine:getInstance():stopAllEffects()
end

--是否开启了特效音乐
function isOpenEffects()
	return mOpenEffect
end




--进入后台 回调
function onDidEnterBackground()
	pauseMusic()
	pauseAllEffects()
end

--后台返回 回调
function onWillEnterForeground()
	resumeMusic()
	resumeAllEffects()

	--这里是2.x的bug解决方法,不清楚3.x是否还存在.
	if (mOpenMusic==true and mRecordName~="" and mRecordIsLoop==true and cc.SimpleAudioEngine:getInstance():isMusicPlaying()==false) then
		playMusic(mRecordName, mRecordIsLoop)
	end
end


return audioManager
