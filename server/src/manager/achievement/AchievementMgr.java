package manager.achievement;

public class AchievementMgr {
	public static AchievementMgr inst = null;
	
	public AchievementMgr getInstance() {
		if(inst==null) {
			inst = new AchievementMgr();
		}
		
		return inst;
	}
}
