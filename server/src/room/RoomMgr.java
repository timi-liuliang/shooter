package room;

import java.util.ArrayList;
import java.util.HashMap;
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
	public HashMap<Long, PlayerState>  players_searching = new HashMap<Long, PlayerState>();
	public HashMap<Long, PlayerState>  players_in_battle = new HashMap<Long, PlayerState>();
	
	
	public static RoomMgr instance() {
		if(inst==null)
			inst = new RoomMgr();

		return inst;
	}
	
	public void process() {
		// 匹配
		if(players_searching.size()>2) {
			
		}
		
		// 更新房间 
		//for()
	}
	
	public void new_room(long player0, long player1) {
		Room room = new Room();
		
		PlayerState ps0 = new PlayerState(player0, room.hashCode());
		players_in_battle.put(player0, ps0);
		
		PlayerState ps1 = new PlayerState(player0, room.hashCode());
		players_in_battle.put(player1, ps1);
		
		rooms.put(room.hashCode(), room);
	}
	
	public boolean add_player(long player) {
		if(players_in_battle.containsKey(player)) {
			return false;
		}
		else {
			return true;
		}
	}
}
