
--游戏配置 
local GameConfig = {

  serverVersion = 2,  --服务器版本号, 用于游戏中提示用户更新版本

  --先访问登录服, 然后由登录服返回游戏服URL给客户端
  -- loginHost = "http://192.168.216.131/",  --虚拟机IP
  -- loginHost = "http://10.103.241.63:8080/" --windows主机将8080端口映射成虚拟机IP,外部访问该PC端口就相当于访问虚拟机IP
  loginHost = "http://116.196.79.76/" --云服务器主机
}

return GameConfig 


