package manager.player;

import db.db;
import db.player_table;
import java.util.HashMap;
import java.util.Iterator;

import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelHandlerContext;
import com.google.gson.Gson;

import App.app;

import java.util.Timer;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import manager.room.Room;
import manager.room.RoomMgr;

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
	public static HashMap<Long, Player>	    id_player_map = new HashMap<Long, Player>();
	public ChannelHandlerContext 		   	mChannelCtx = null;
	protected long							mLastTickTime = 0;
	protected Account						mAccount = new Account();
	protected player_table					table = new player_table();						// 玩家表信息
	protected Info					   		info = new Info();	
	protected float							nonHeartBeatTime = 0.f;
	protected float							saveDBTime = 0.f;
	protected static float					players_update_time = 0.f;

	public Player(ChannelHandlerContext channelCtx) {
			
		mChannelCtx = channelCtx;
	}
	
	public static void updateAll() {
		for(Player player : players.values()) {
			player.update();
		}
		
		players_update_time += 5.f;
		if(players_update_time>60.f) {
			players_update_time = 0.f;
			app.logger().info(String.format("active players count [%d]", players.size()));
		}
	}
	
	public void update() {
		saveDBTime += 5.f;
		if (saveDBTime > 3000.f) {
			saveToDB();
			saveDBTime = 0.f;
		}
		
		nonHeartBeatTime += 5.f;
		if(nonHeartBeatTime > 30.f) {
			disconnectPlayer(mChannelCtx);
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
	
	public static Player getById(Long playerID) {
		if(id_player_map.containsKey(playerID)) {
			return id_player_map.get(playerID);
		}else {
			return null;
		}
	}
	
	public static Player get(Integer ctxID) {
		if( players.containsKey(ctxID)) {
			return players.get(ctxID);
		}
		else {
			return null;
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
	
	public void on_heart_beat(ByteBuf msg) {
		nonHeartBeatTime = 0.f;
		
		mChannelCtx.write(msg);
	}
	
	public void setAccount(long account) {	
		// disconnect same account
		if(!db.instance().isPlayerExist(account)) {
			
			refreshPlayerToJson();
			db.instance().saveNewPlayer(this.mAccount.table.account, table.info);
			
			loadFromDB();	
		}else{
			// disconnect same name player
			disconnectPlayer(account);
			
			// init this player
			loadFromDB();
			
			players.put(mChannelCtx.hashCode(), this);
			id_player_map.put(table.player, this);
		}
		
		sendPlayerInfo();
		
		// User logined
		RoomMgr.instance().on_player_logined( table.player);
	}
	
	protected void disconnectPlayer(long account) {
		for(HashMap.Entry<Integer, Player> entry : players.entrySet()) {
			Player player = entry.getValue();
			if (player.mAccount.table.account==account) {
				player.disconnect();			
				break;
			}
		}
	}
	
	public static void disconnectPlayer(ChannelHandlerContext ctx) {
		if( players.containsKey(ctx.hashCode())) {
			Player player = players.get(ctx.hashCode());
			player.disconnect();
		}
	}
	
	public void disconnect() {
		app.logger().info(String.format("Player [%d] offline, CurrentPlayers [%d]", table.player, players.size()-1));
		
		this.saveToDB();
		this.mChannelCtx.disconnect();
		this.mChannelCtx.close();
		
		id_player_map.remove(this.get_id());
		RoomMgr.instance().remove_player(get_id());
		players.remove(mChannelCtx.hashCode());
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
		mAccount.saveToDB();
		
		if(refreshPlayerToJson()) {
			db.instance().savePlayer(table.player, table.info);
			app.logger().info(String.format("account [%s] player [%d] save to db", table.account, table.player));
		}
	}
	
	public void loadFromDB() {
		table = db.instance().getPlayerTable( mAccount.table.account);
		
		Gson gson = new Gson();
		info = gson.fromJson( table.info, Info.class);
	}
	
	// ---------------------receive---------------------
	public void on_battle_player_shoot(protocol.battle_player_shoot msg){
		Room room = RoomMgr.instance().getRoom(get_id());
		if(room!=null) {
			room.on_batle_player_shoot(get_id(), msg);
		}
	}
	
	public void on_battle_switch_turn() {
		Room room = RoomMgr.instance().getRoom(get_id());
		if(room!=null) {
			room.on_batle_switch_turn(get_id());
		}
	}
	
	public void on_battle_blood_changed(protocol.battle_player_blood msg) {
		Room room = RoomMgr.instance().getRoom(get_id());
		if(room!=null) {
			room.on_batle_player_blood_changed(get_id(), msg);
		}
	}
	
	public void on_battle_sync_aim_degree(protocol.battle_sync_aim_degree msg) {
		Room room = RoomMgr.instance().getRoom(get_id());
		if(room!=null) {
			room.on_battle_sync_aim_degree(get_id(), msg);
		}
	}
	
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
	public long get_id() {
		return table.player;
	}
	
	public void sendPlayerInfo() {
		protocol.player_info msg = new protocol.player_info();
		msg.player = table.player;
		msg.name = info.baseInfo.name;
		mChannelCtx.write(msg.data());
	}
	
	// send info to client
	public void sendBackpackInfo(){
		info.backpack.sendBackpackInfo(mChannelCtx);
	}
	
	public void sendMsg(ByteBuf buf) {
		mChannelCtx.writeAndFlush(buf);
	}
	
	// --------------------search room-------------------------
	public void search_room_begin() {
		RoomMgr.instance().add_player(get_id());
			
		protocol.search_room_result msg = new protocol.search_room_result();
		msg.result = 1;
		mChannelCtx.write(msg.data());
	}
	
	public void search_room_end() {
		RoomMgr.instance().remove_player(get_id());
		
		protocol.search_room_result msg = new protocol.search_room_result();
		msg.result = 0;
		mChannelCtx.write(msg.data());
	}	
}
