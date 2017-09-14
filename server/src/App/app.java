package App;

import java.util.Timer;
import java.util.TimerTask;
import net.SocketServer;
import org.apache.logging.log4j.Logger;

import http.HttpServer;

import org.apache.logging.log4j.LogManager;

public class app {
	// 定义一个静态日志变量
	private static final Logger logger = LogManager.getLogger("shooter");
	
	public static void main(String[] args){
		logger.info("--------------");
		logger.info("|Start server|");
		logger.info("--------------");
		
		// 数据保存计时器
		Timer dbSaveTimer = new Timer();
		dbSaveTimer.scheduleAtFixedRate(new TimerTask() {
			@Override
			public void run() {
				player.Player.updateAll();
			}
		}, 5*1000, 5*1000);
		
		// 战场更新计时器
		Timer roomUpdateTimer = new Timer();
		roomUpdateTimer.scheduleAtFixedRate(new TimerTask() {
			@Override
			public void run() {
				room.RoomMgr.update();
			}
		}, 0, 1000);
		
		// 启动服务
		SocketServer server = SocketServer.getInstance();
		server.start();
		
		HttpServer httpServer = HttpServer.getInstance();
		httpServer.start();
	}
	
	public static Logger logger() {
		return logger;
	}
}
