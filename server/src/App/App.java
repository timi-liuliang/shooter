package App;

import java.util.Timer;
import java.util.TimerTask;
import net.SocketServer;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.LogManager;

public class App {
	// 定义一个静态日志变量
	private static final Logger logger = LogManager.getLogger("shooter");
	
	public static void main(String[] args){
		logger.trace("Start server");
		
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
		
		logger.trace("Exite server");
	}
}
