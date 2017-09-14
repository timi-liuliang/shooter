package manager.room;

import io.netty.buffer.ByteBuf;
import manager.player.Player;

enum GameState{
	GS_PREPARE,
	GS_PLAYER_READY,
	GS_PLAYER0_TURN,
	GS_PLAYER1_TURN,
	GS_END
}

public class Room {
	protected static  Integer m_roomCreated = 0;
	protected Integer m_id;
	public GameState  m_gameState = GameState.GS_PREPARE;
	public float  	  m_battleTime= 0.f;
	public float	  m_turnTime = 30.f;
	public Long 	  m_player0 = null;
	public Long 	  m_player1 = null;
	protected int	  m_player0Blood = 100;
	protected int	  m_player1Blood = 100;
	
	public Room(){
		m_id = m_roomCreated++;
	}
	
	public Integer getID() {
		return m_id;
	}
	
	public void process(float delta){
		m_battleTime += delta;
		if(m_gameState == GameState.GS_PLAYER_READY && m_battleTime>=1.f) {
			m_gameState = GameState.GS_PLAYER0_TURN;
			sendBattleTurnBegin(GameState.GS_PLAYER0_TURN);
			
			protocol.battle_begin msg = new protocol.battle_begin();
			sendMsgToPlayer(m_player0,msg.data());
			sendMsgToPlayer(m_player1,msg.data());
		}
		else if(m_gameState==GameState.GS_PLAYER0_TURN) {
			m_turnTime -= delta;
			if(m_turnTime < 0.f) {
				on_batle_switch_turn(m_player0);
			}
		}
		else if(m_gameState==GameState.GS_PLAYER1_TURN) {
			m_turnTime -= delta;
			if(m_turnTime < 0.f) {
				on_batle_switch_turn(m_player1);
			}
		}
		else if(m_gameState==GameState.GS_END) {
			
		}
		
		sendBattleTime();
	}
	
	void addPlayer( Long p0, Long p1) {
		m_player0 = p0;
		m_player1 = p1;
		
		protocol.battle_player_enter msg0 = new protocol.battle_player_enter();
		msg0.pos = 0;
		msg0.player = m_player0;
		msg0.name = "player_0";
		sendMsgToPlayer( m_player0, msg0.data());
		sendMsgToPlayer(m_player1,msg0.data());
		
		protocol.battle_player_enter msg1 = new protocol.battle_player_enter();
		msg1.pos = 1;
		msg1.player = m_player1;
		msg1.name = "player_1";
		sendMsgToPlayer(m_player0,msg1.data());
		sendMsgToPlayer(m_player1,msg1.data());
		
		m_gameState = GameState.GS_PLAYER_READY;
	}
	
	void sendBattleTime() {
		protocol.battle_time msg = new protocol.battle_time();
		msg.battle_time = (int)m_battleTime;
		msg.turn_time   = (int)m_turnTime;
		sendMsgToPlayer(m_player0,msg.data());
		sendMsgToPlayer(m_player1,msg.data());
	}
	
	void sendBattleTurnBegin(GameState state) {
		if(state==GameState.GS_PLAYER0_TURN) {
			protocol.battle_turn_begin msg = new protocol.battle_turn_begin();
			msg.player = m_player0;
			sendMsgToPlayer(m_player0,msg.data());
			sendMsgToPlayer(m_player1,msg.data());
		}
		else if(state == GameState.GS_PLAYER1_TURN) {
			protocol.battle_turn_begin msg = new protocol.battle_turn_begin();
			msg.player = m_player1;
			sendMsgToPlayer(m_player0,msg.data());
			sendMsgToPlayer(m_player1,msg.data());
		}
	}
	
	public void on_batle_player_shoot(Long player, protocol.battle_player_shoot msg) {
		if(player==m_player0 && m_gameState==GameState.GS_PLAYER0_TURN) {
			sendMsgToPlayer(m_player0,msg.data());
			sendMsgToPlayer(m_player1,msg.data());
		}
		else if (player==m_player1 && m_gameState==GameState.GS_PLAYER1_TURN) {		
			sendMsgToPlayer(m_player0,msg.data());
			sendMsgToPlayer(m_player1,msg.data());
		}
	}
	
	public void on_batle_switch_turn(Long player) {
		if(player==m_player0 && m_gameState==GameState.GS_PLAYER0_TURN) {
			m_gameState = GameState.GS_PLAYER1_TURN;
			m_turnTime = 30.f;
			sendBattleTurnBegin(GameState.GS_PLAYER1_TURN);
		}
		else if (player==m_player1 && m_gameState==GameState.GS_PLAYER1_TURN) {
			m_gameState = GameState.GS_PLAYER0_TURN;
			m_turnTime = 30.f;
			sendBattleTurnBegin(GameState.GS_PLAYER0_TURN);
		}
	}
	
	public void on_batle_player_blood_changed(Long player, protocol.battle_player_blood msg) {
		if(player==m_player0) {
			m_player0Blood = msg.self_blood;
			m_player1Blood = msg.enemy_blood;
		}
		else if(player==m_player1) {
			m_player1Blood = msg.self_blood;
			m_player0Blood = msg.enemy_blood;
		}
		
		// Í¬²½ÑªÁ¿
		protocol.battle_player_shoot_result msg_sr = new protocol.battle_player_shoot_result();
		msg_sr.player0_blood = m_player0Blood;
		msg_sr.player1_blood = m_player1Blood;
		sendMsgToPlayer(m_player0, msg_sr.data());
		sendMsgToPlayer(m_player1, msg_sr.data());
		
		if(m_player0Blood <= 0 || m_player1Blood<=0) {
			RoomMgr.instance().close_room(getID(), m_player0, m_player1);
		}
	}
	
	public void on_battle_sync_aim_degree(Long player, protocol.battle_sync_aim_degree msg) {
		if(player==m_player0) {
			sendMsgToPlayer(m_player1, msg.data());
		}
		else if (player==m_player1) {
			sendMsgToPlayer(m_player0, msg.data());
		}
	}
	
	public void on_battle_player_relogin(long player) {
		protocol.battle_player_relogin msg = new protocol.battle_player_relogin();
		msg.pos0 = 0;
		msg.player0 = m_player0;
		msg.name0 = "player_0";
		msg.pos1 = 1;
		msg.player1 = m_player1;
		msg.name1 = "player_1";
		msg.battle_time = (int)m_battleTime;
		msg.turn_time   = (int)m_turnTime;
		msg.player0_blood = m_player0Blood;
		msg.player1_blood = m_player1Blood;
		msg.turn_player = m_gameState==GameState.GS_PLAYER0_TURN ? m_player0 : m_player1;
		
		sendMsgToPlayer(player, msg.data());
	}
	
	protected void sendMsgToPlayer( Long playerID, ByteBuf buf) {
		Player player = Player.getById( playerID);
		if(player!=null) {
			player.sendMsg(buf);
		}
		else {
			Player player0 = Player.getById(m_player0);
			Player player1 = Player.getById(m_player1);
			if(player0==null && player1==null) {
				RoomMgr.instance().close_room(getID(), m_player0, m_player1);
			}
		}
	}
}
