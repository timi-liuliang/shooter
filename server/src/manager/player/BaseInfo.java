package manager.player;

import io.netty.channel.ChannelHandlerContext;

public class BaseInfo {
	protected String	name="";
	protected int		gameTime = 0;
	protected int		curBlood = 50;
	protected int		maxBlood = 50;
	protected int		maxScore = 0;
	
	public void onAttacked(int damage) {
		curBlood = Math.min(Math.max(curBlood - damage, 0), maxBlood);
	}
	
	public void onCure(int cure) {
		curBlood = Math.min(Math.max(curBlood + cure, 0), maxBlood);
	}
	
	public void addGameTime(long delta) {
		if(curBlood > 0) {
			gameTime += delta;
		}
	}
	
	public void sendBloodInfo(ChannelHandlerContext ctx) {
		//protocol.blood_info bp_cell = new protocol.blood_info();
		//bp_cell.cur_blood = curBlood;
		//bp_cell.max_blood = maxBlood;
		//ctx.write(bp_cell.data());
	}
	
	public void sendGameTime(ChannelHandlerContext ctx) {
		protocol.game_time bp_cell = new protocol.game_time();
		bp_cell.time = gameTime;
		ctx.write(bp_cell.data());
	}
	
	public boolean onNewMaxScore(int score) {
		//if (score>maxScore) {
		//	maxScore = score;
			return true;
		//}
		
		//return false;
	}
}
