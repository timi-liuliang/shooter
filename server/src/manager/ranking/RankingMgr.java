package manager.ranking;

public class RankingMgr {
	private static RankingMgr inst = null;
	
	public RankingMgr getInstance() {
		if(inst==null) {
			inst = new RankingMgr();
		}
		
		return inst;
	}
}
