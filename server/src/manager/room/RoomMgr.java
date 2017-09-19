package manager.room;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.concurrent.ConcurrentHashMap;

import App.app;
import manager.player.Player;

class PlayerState{
	protected long	  player;		// 玩家id
	protected Integer roomId;		// 房间ID
	
	public PlayerState( long player, Integer room) {
		this.player = player;
		this.roomId = room;
	}
}

public class RoomMgr {
	protected static RoomMgr inst = null;
	public static ConcurrentHashMap<Integer, Room>  rooms 			= new ConcurrentHashMap<Integer, Room>();
	public static long 					   			rooms_update_time = 0;
	public ConcurrentHashMap<Long, PlayerState>  players_searching = new ConcurrentHashMap<Long, PlayerState>();
	public ConcurrentHashMap<Long, PlayerState>  players_in_battle = new ConcurrentHashMap<Long, PlayerState>();
	
	public static RoomMgr instance() {
		if(inst==null)
			inst = new RoomMgr();

		return inst;
	}
	
	public static void update(long delta){
		rooms_update_time += delta;
		if(rooms_update_time>1000) {
			RoomMgr.instance().process(1.0f);
			rooms_update_time -= 1000;
		}
	}
	
	public void process(float delta) {
		// 匹配
		if(players_searching.size()>=2) {
			Iterator it = players_searching.entrySet().iterator();
			HashMap.Entry pair = (HashMap.Entry)it.next();
			Long player0 = (Long) pair.getKey();
			it.remove();
			
			pair = (HashMap.Entry)it.next();
			Long player1 = (Long) pair.getKey();
			it.remove();
			
			new_room(player0, player1);
		}
		
		// 更新房间
		Iterator it = rooms.entrySet().iterator();
		while(it.hasNext()){
			HashMap.Entry pair = (HashMap.Entry)it.next();
			((Room) pair.getValue()).process(delta);
		}
	}
	
	public void new_room(Long player0, Long player1) {
		Room room = new Room();	

		room.addPlayer( player0, player1);
		rooms.put(room.getID(), room);
		
		PlayerState ps0 = new PlayerState(player0, room.getID());
		players_in_battle.put(player0, ps0);
		
		PlayerState ps1 = new PlayerState(player0, room.getID());
		players_in_battle.put(player1, ps1);
		
		System.out.println(String.format("new battle field[%d]", room.getID()));
	}
	
	public void close_room(Integer roomID, Long player0, Long player1) {
		if(rooms.containsKey(roomID)) {
			rooms.remove(roomID);
			
			System.out.println(String.format("close battle field [%d], active count [%d]",roomID, rooms.size()));
		}
		
		if(players_in_battle.containsKey(player0)) {
			players_in_battle.remove(player0);
		}
		
		if(players_in_battle.containsKey(player1)) {
			players_in_battle.remove(player1);
		}
	}
	
	public void on_player_logined(Long player) {
		if(isPlayerInBattle(player)) {
			Room room = getRoom(player);
			if(room!=null) {
				room.on_battle_player_relogin(player);
			}
		}
	}
	
	public boolean add_player(Long player) {
		if(players_searching.containsKey(player)) {
			return false;
		}
		else {
			players_searching.put(player, new PlayerState(player, 0));
			return true;
		}
	}
	
	public boolean remove_player(Long player){
		if(players_searching.containsKey(player)) {
			players_searching.remove(player);
			return true;
		}
		else {
			return false;
		}
	}
	
	public boolean isPlayerInBattle(long player) {
		if(players_in_battle.containsKey(player)) {
			return true;
		}
		else {
			return false;
		}
	}
	
	public Integer getRoomID(long player) {
		PlayerState state = players_in_battle.get(player);
		if(rooms.containsKey(state.roomId)) {
			return state.roomId;
		}
		else {
			return -1;
		}
	}
	
	public Room getRoom(long player) {
		PlayerState state = players_in_battle.get(player);
		if(rooms.containsKey(state.roomId)) {
			return rooms.get(state.roomId);
		}
		else {
			return null;
		}
	}
}
