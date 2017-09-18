package App;

import java.util.Timer;
import java.util.TimerTask;
import net.socket.SocketServer;
import quartz.JobMgr;

import org.apache.logging.log4j.Logger;

import manager.ranking.RankingMgr;
import net.http.HttpServer;

import org.apache.logging.log4j.LogManager;

public class app {
	// 定义一个静态日志变量
	private static final Logger logger = LogManager.getLogger("shooter");
	
	public static void main(String[] args){
		logger.info("--------------");
		logger.info("|Start server|");
		logger.info("--------------");
		
		// 程序终止处理
		KillHandler killHandler = new KillHandler();
		killHandler.registerSignal("TERM");
		
		// 开启定时任务
		JobMgr.getInstance().startJobs();
		
		// 排行榜
		RankingMgr.getInstance();
		
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
