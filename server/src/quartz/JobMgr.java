package quartz;

import java.text.ParseException;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

import App.app;

public class JobMgr {
	private static JobMgr inst = null;
	
	private JobMgr() {
		
	}
	
	public static JobMgr getInstance() {
		if(inst==null) {
			inst = new JobMgr();
		}
		
		return inst;
	}
	
	// 初始化所有任务
	public void startJobs() {
		// 数据保存计时器
		Timer dbSaveTimer = new Timer();
		dbSaveTimer.scheduleAtFixedRate(new TimerTask() {
			@Override
			public void run() {
				manager.player.Player.updateAll();
				manager.ranking.RankingMgr.getInstance().saveToDB();
			}
		}, 5*1000, 5*1000);
		
		// 战场更新计时器
		Timer roomUpdateTimer = new Timer();
		roomUpdateTimer.scheduleAtFixedRate(new TimerTask() {
			@Override
			public void run() {
				manager.room.RoomMgr.update();
			}
		}, 0, 1000);
	}
}
