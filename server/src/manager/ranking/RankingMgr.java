package manager.ranking;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

import com.google.gson.Gson;

import App.app;
import db.db;

class HigherChuangGuanScore{
	protected long		account;
	protected String	name;
	protected int		score;
	
	public HigherChuangGuanScore(long account_, String name_, int score_) {
		account = account_;
		name = name_;
		score = score_;
	}
}


class ChuangGuanScoreRanking{
	private int			lowestScore = 0;
	private int			rankingSize  = 1000;
	public ArrayList<HigherChuangGuanScore> scoreRanking = new ArrayList<HigherChuangGuanScore>();
	
	
	public void onChuangGuanScoreChanged(long account, String name, int score) {
		if(score > lowestScore)
		{
			int idx = getIdxByAccount(account);
			if(idx==-1) {
				scoreRanking.add(new HigherChuangGuanScore(account, name, score));	
			}
			else {
				scoreRanking.set(idx, new HigherChuangGuanScore(account, name, score));
			}
				
			sort();		
			keepSize(rankingSize);
			lowestScore = scoreRanking.get(scoreRanking.size()-1).score;
		}
	}
	
	private void sort() {
		Comparator<HigherChuangGuanScore> comparator = new Comparator<HigherChuangGuanScore>() {
			public int compare(HigherChuangGuanScore s1, HigherChuangGuanScore s2) {
				return s1.score - s2.score;
			}
		};
		
		
		Collections.sort(scoreRanking, comparator);
	}
	
	private int getIdxByAccount(long account) {
		for(int i=0; i<scoreRanking.size(); i++) {
			if(scoreRanking.get(i).account==account) {
				return i;
			}	
		}
		
		return -1;
	}
	
	private void keepSize(int size) {
		while(scoreRanking.size()>size) {
			scoreRanking.remove(scoreRanking.size()-1);
		}
	}
}

public class RankingMgr {
	private static RankingMgr inst = null;
	public ChuangGuanScoreRanking higerChuangGuanRanking = new ChuangGuanScoreRanking();
	
	public static RankingMgr getInstance() {
		if(inst==null) {
			inst = new RankingMgr();
		}
		
		return inst;
	}
	
	
	public void onChuangGuanScoreChanged(long account, String name, int score) {
		higerChuangGuanRanking.onChuangGuanScoreChanged(account, name, score);
	}
	
	public void refreshJson() {
		
	}
	
	public String getRankingInJson() {
		Gson gson = new Gson();	
		String json = gson.toJson(higerChuangGuanRanking);
		
		return json;
	}
	
	public void saveToDB() {
//		mAccount.saveToDB();
		
//		if(refreshPlayerToJson()) {
//			db.instance().savePlayer(table.player, table.info);
//			app.logger().info(String.format("account [%s] player [%d] save to db", table.account, table.player));
//		}
	}
	
	public void loadFromDB() {
//		table = db.instance().getPlayerTable( mAccount.table.account);
		
//		Gson gson = new Gson();
//		info = gson.fromJson( table.info, Info.class);
	}
}
