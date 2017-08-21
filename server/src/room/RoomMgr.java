package room;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import player.Player;

class PlayerState{
	protected long	  player;		// 玩家id
	protected Integer roomId;		// 房间ID
	
	public PlayerState( long player, Integer room) {
		this.player = player;
		this.roomId = roomId;
	}
}

public class RoomMgr {
	protected static RoomMgr inst = null;
	public static HashMap<Integer, Room>  rooms 			= new HashMap<Integer, Room>();
	public HashMap<Integer, PlayerState>  players_searching = new HashMap<Integer, PlayerState>();
	public HashMap<Integer, PlayerState>  players_in_battle = new HashMap<Integer, PlayerState>();
	
	public static RoomMgr instance() {
		if(inst==null)
			inst = new RoomMgr();

		return inst;
	}
	
	public static void update(){
		RoomMgr.instance().process(1.f);
	}
	
	public void process(float delta) {
		// 匹配
		if(players_searching.size()>2) {
			Iterator it = players_searching.entrySet().iterator();
			HashMap.Entry pair = (HashMap.Entry)it.next();
			Integer player0 = (Integer) pair.getKey();
			it.remove();
			
			pair = (HashMap.Entry)it.next();
			Integer player1 = (Integer) pair.getKey();
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
	
	public void new_room(Integer player0, Integer player1) {
		Room room = new Room();
		
		PlayerState ps0 = new PlayerState(player0, room.hashCode());
		players_in_battle.put(player0, ps0);
		
		PlayerState ps1 = new PlayerState(player0, room.hashCode());
		players_in_battle.put(player1, ps1);
		
		room.addPlayer( player0, player1);
		rooms.put(room.hashCode(), room);
	}
	
	public boolean add_player(Integer player) {
		if(players_searching.containsKey(player)) {
			return false;
		}
		else {
			players_searching.put(player, new PlayerState(player, 0));
			return true;
		}
	}
	
	public boolean remove_player(Integer player){
		if(players_searching.containsKey(player)) {
			players_searching.remove(player);
			return true;
		}
		else {
			return false;
		}
	}
}
