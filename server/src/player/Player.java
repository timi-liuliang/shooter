package player;

import db.db;
import java.util.HashMap;
import java.util.Iterator;
import io.netty.channel.ChannelHandlerContext;
import com.google.gson.Gson;
import java.util.Timer;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

class Info{
	protected BaseInfo						baseInfo = null;
	protected Backpack					   	backpack = null;
	protected Building						building = null;
	protected Currency						currency = null;
	
	public Info() {
		baseInfo = new BaseInfo();
		backpack = new Backpack();
		building = new Building();
		currency = new Currency();
	}
}

public class Player {
	public static HashMap<Integer, Player>  players = new HashMap<Integer, Player>();
	public ChannelHandlerContext 		   	mChannelCtx = null;
	protected Account						mAccount;
	protected long							mPlayer;						// ÕÊº“ID
	protected String					   	mJsonData = "{}";			// info in json format
	protected Info					   		mInfo = new Info();
	protected long							mLastTickTime = 0;
	
	public Player(ChannelHandlerContext channelCtx) {
			
		mChannelCtx = channelCtx;
	}
	
	public static void update() {
		for(Player player : players.values()) {
			player.saveToDB();
		}
	}
	
	public static Player get(ChannelHandlerContext ctx) {
		int ctxID = ctx.hashCode();
		if( players.containsKey(ctxID)) {
			return players.get(ctxID);
		}
		else {
			Player player = new Player(ctx);		
			
			return player;
		}		
	}
	
	//  π”√” œ‰√‹¬Î◊¢≤·
	public void registerByEmail(String email, String password) {
		mAccount.registerByEmail(email, password);
	}
	
	public void setAccount(long account, long player) {
		// load player data from database
		//this.mAccount = account;
		this.mPlayer = player;
		
		// disconnect same account
		if(!db.instance().isPlayerExist(mPlayer)) {
			
			initBackpack();
			
			refreshPlayerToJson();
			db.instance().saveNewPlayer(this.mAccount.id, this.mJsonData);
		}else {
			// disconnect same name player
			disconnectPlayer(mPlayer);
			
			// init this player
			loadFromDB();
			
			players.put(mChannelCtx.hashCode(), this);
		}
	}
	
	protected void disconnectPlayer(long playerid) {
		for(HashMap.Entry<Integer, Player> entry : players.entrySet()) {
			Player player = entry.getValue();
			if (player.mPlayer==playerid) {
				player.saveToDB();
				player.mChannelCtx.disconnect();
				
				players.remove(entry.getKey());
				
				break;
			}
		}
	}
	
	public static void disconnectPlayer(ChannelHandlerContext ctx) {
		if( players.containsKey(ctx.hashCode())) {
			Player player = players.get(ctx.hashCode());

			System.out.println(String.format("Player [%d] offline, CurrentPlayers [%d]", player.mPlayer, players.size()-1));
			
			player.saveToDB();
			player.mChannelCtx.disconnect();	
			players.remove(ctx.hashCode());
		}
	}
	
	protected boolean initBackpack(){
		try{
			SAXReader reader = new SAXReader();
			Document document = reader.read("cfg/init_backbag.xml");
			
			Element rootElement = document.getRootElement();
			for(Iterator it=rootElement.elementIterator(); it.hasNext();){
				Element e = (Element)it.next();
				
				String strId    = e.attributeValue("id");
				String strCount = e.attributeValue("count");
				int counter = Integer.parseInt( strCount);		
				int id     = Integer.parseInt( strId);
				
				mInfo.backpack.AddItem(id, counter, 0);
			}	
		} catch(DocumentException e){
			e.printStackTrace();
		}
	
		return true;
	}
	
	protected boolean refreshPlayerToJson() {
		Gson gson = new Gson();
		String new_json = gson.toJson(mInfo);	
		if(mJsonData!=new_json)
		{
			mJsonData = new_json;
			
			return true;
		}
			
		return false;
	}
	
	public void saveToDB() {
		if(refreshPlayerToJson()) {
			db.instance().savePlayer(mPlayer, mJsonData);
			System.out.println(String.format("account [%s] player [%d] save to db", mAccount, mPlayer));
		}
	}
	
	public void loadFromDB() {
		Gson gson = new Gson();
		mJsonData = db.instance().getPlayerInfo( mAccount.id, mPlayer);
		mInfo = gson.fromJson( mJsonData, Info.class);
	}
	
	// ---------------------receive---------------------
	
	public void collectItem(int id, int count, int type) {
		mInfo.backpack.collectItem(id, count, type, mChannelCtx);
	}
	
	public void onEatItem(int slotIdx) {
		Cell cell = mInfo.backpack.useItem(slotIdx, mChannelCtx);
		if(cell!=null) {
			mInfo.baseInfo.onCure( 25);
			mInfo.baseInfo.sendBloodInfo(mChannelCtx);
		}
	}
	
	public void onAttacked(int damage) {
		mInfo.baseInfo.onAttacked(damage);
		mInfo.baseInfo.sendBloodInfo(mChannelCtx);
	}
	
	public void onResurgence(int type){
		if( type==0) {
			mInfo.baseInfo.curBlood = mInfo.baseInfo.maxBlood;
			mInfo.baseInfo.sendBloodInfo(mChannelCtx);
		}
	}
	
	public void onAddGameTime(int time) {
		long elapsedTime = time;
		long curTime = System.currentTimeMillis();
		long serverDelta = curTime - mLastTickTime;
		if(serverDelta - time > 1.0){
			elapsedTime = Math.min(serverDelta, time);
			elapsedTime = Math.min(elapsedTime, 5);
		}
			
		mInfo.baseInfo.addGameTime(elapsedTime);
		mInfo.baseInfo.sendGameTime(mChannelCtx);
		
		mLastTickTime = curTime;
	}
	
	// ---------------------send---------------------
	
	public void sendBaseInfo() {
		mInfo.baseInfo.sendBloodInfo(mChannelCtx);
		mInfo.baseInfo.sendGameTime(mChannelCtx);
	}
	
	// send info to client
	public void sendBackpackInfo(){
		mInfo.backpack.sendBackpackInfo(mChannelCtx);
	}
}
