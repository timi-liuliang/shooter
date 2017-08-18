package player;

import db.db;
import db.player_table;
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
	protected long							mLastTickTime = 0;
	protected Account						mAccount = new Account();
	protected player_table					table = new player_table();						// 玩家表信息
	protected Info					   		info = new Info();
	
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
	
	// 使用邮箱密码注册
	public void registerByEmail(String email, String password) {
		mAccount.registerByEmail(email, password, mChannelCtx);
	}
	
	// 使用邮箱密码登录
	public void loginByEmail(String email, String password) {
		if (mAccount.loginByEmail(email, password, mChannelCtx)){
			setAccount(mAccount.table.account);
		}
	}
	
	// 使用唯一ID登录
	public void loginByOSID(String osid) {
		if (mAccount.loginByOSID(osid, mChannelCtx)){
			setAccount(mAccount.table.account);
		}
	}
	
	public void setAccount(long account) {	
		// disconnect same account
		if(!db.instance().isPlayerExist(account)) {
			
			refreshPlayerToJson();
			db.instance().saveNewPlayer(this.mAccount.table.account, table.info);
			
			loadFromDB();	
		}else {
			// disconnect same name player
			disconnectPlayer(account);
			
			// init this player
			loadFromDB();
			
			players.put(mChannelCtx.hashCode(), this);
		}
	}
	
	protected void disconnectPlayer(long account) {
		for(HashMap.Entry<Integer, Player> entry : players.entrySet()) {
			Player player = entry.getValue();
			if (player.mAccount.table.account==account) {
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

			System.out.println(String.format("Player [%d] offline, CurrentPlayers [%d]", player.table.player, players.size()-1));
			
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
				
				info.backpack.AddItem(id, counter, 0);
			}	
		} catch(DocumentException e){
			e.printStackTrace();
		}
	
		return true;
	}
	
	protected boolean refreshPlayerToJson() {	
		Gson gson = new Gson();	
		String new_json = gson.toJson(info);	
		if(!table.info.equals(new_json))
		{
			table.info = new_json;
			
			return true;
		}
			
		return false;
	}
	
	public void saveToDB() {
		if(refreshPlayerToJson()) {
			db.instance().savePlayer(table.player, table.info);
			System.out.println(String.format("account [%s] player [%d] save to db", table.account, table.player));
		}
	}
	
	public void loadFromDB() {
		table = db.instance().getPlayerTable( mAccount.table.account);
		
		Gson gson = new Gson();
		info = gson.fromJson( table.info, Info.class);
	}
	
	// ---------------------receive---------------------
	
	public void collectItem(int id, int count, int type) {
		info.backpack.collectItem(id, count, type, mChannelCtx);
	}
	
	public void onEatItem(int slotIdx) {
		Cell cell = info.backpack.useItem(slotIdx, mChannelCtx);
		if(cell!=null) {
			info.baseInfo.onCure( 25);
			info.baseInfo.sendBloodInfo(mChannelCtx);
		}
	}
	
	public void onAttacked(int damage) {
		info.baseInfo.onAttacked(damage);
		info.baseInfo.sendBloodInfo(mChannelCtx);
	}
	
	public void onResurgence(int type){
		if( type==0) {
			info.baseInfo.curBlood = info.baseInfo.maxBlood;
			info.baseInfo.sendBloodInfo(mChannelCtx);
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
			
		info.baseInfo.addGameTime(elapsedTime);
		info.baseInfo.sendGameTime(mChannelCtx);
		
		mLastTickTime = curTime;
	}
	
	// ---------------------send---------------------
	
	public void sendBaseInfo() {
		info.baseInfo.sendBloodInfo(mChannelCtx);
		info.baseInfo.sendGameTime(mChannelCtx);
	}
	
	// send info to client
	public void sendBackpackInfo(){
		info.backpack.sendBackpackInfo(mChannelCtx);
	}
}
