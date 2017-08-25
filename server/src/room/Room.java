package room;

import io.netty.buffer.ByteBuf;
import player.Player;

enum GameState{
	GS_PREPARE,
	GS_PLAYER_READY,
	GS_PLAYER0_TURN,
	GS_PLAYER1_TURN,
	GS_END
}

public class Room {
	public GameState m_gameState = GameState.GS_PREPARE;
	public float  	 m_battleTime= 0.f;
	public float	 m_turnTime = 30.f;
	public Long 	 m_player0 = null;
	public Long 	 m_player1 = null;
	
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
	
	protected void sendMsgToPlayer( Long playerID, ByteBuf buf) {
		Player player = Player.getById( playerID);
		if(player!=null) {
			player.sendMsg(buf);
		}
		else {
			Player player0 = Player.getById(m_player0);
			Player player1 = Player.getById(m_player1);
			if(player0==null && player1==null) {
				RoomMgr.instance().close_room(hashCode(), m_player0, m_player1);
			}
		}
	}
}
