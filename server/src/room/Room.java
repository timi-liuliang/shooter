package room;

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
	public Player 	 m_player0 = null;
	public Player 	 m_player1 = null;
	
	public void process(float delta){
		m_battleTime += delta;
		if(m_gameState == GameState.GS_PLAYER_READY && m_battleTime>=1.f) {
			m_gameState = GameState.GS_PLAYER0_TURN;
			sendBattleTurnBegin(GameState.GS_PLAYER0_TURN);
			
			protocol.battle_begin msg = new protocol.battle_begin();
			m_player0.sendMsg( msg.data());
			m_player1.sendMsg( msg.data());
		}
		else if(m_gameState==GameState.GS_PLAYER0_TURN) {
		
		}
		else if(m_gameState==GameState.GS_PLAYER1_TURN) {
			
		}
		else if(m_gameState==GameState.GS_END) {
			
		}
		
		sendBattleTime();
	}
	
	void addPlayer( Integer p0, Integer p1) {
		m_player0 = Player.get(p0);
		m_player1 = Player.get(p1);
		
		m_player0.setRoom(this);
		m_player1.setRoom(this);
		
		protocol.battle_player_enter msg0 = new protocol.battle_player_enter();
		msg0.pos = 0;
		msg0.player = m_player0.get_id();
		msg0.name = "player_0";
		m_player0.sendMsg(msg0.data());
		m_player1.sendMsg(msg0.data());
		
		protocol.battle_player_enter msg1 = new protocol.battle_player_enter();
		msg1.pos = 1;
		msg1.player = m_player1.get_id();
		msg1.name = "player_1";
		m_player0.sendMsg(msg1.data());
		m_player1.sendMsg(msg1.data());
		
		m_gameState = GameState.GS_PLAYER_READY;
	}
	
	void sendBattleTime() {
		protocol.battle_time msg = new protocol.battle_time();
		msg.time = (int)m_battleTime;
		m_player0.sendMsg(msg.data());
		m_player1.sendMsg(msg.data());
	}
	
	void sendBattleTurnBegin(GameState state) {
		if(state==GameState.GS_PLAYER0_TURN) {
			protocol.battle_turn_begin msg = new protocol.battle_turn_begin();
			msg.player = m_player0.get_id();
			m_player0.sendMsg(msg.data());
			m_player1.sendMsg(msg.data());
		}
		else if(state == GameState.GS_PLAYER1_TURN) {
			protocol.battle_turn_begin msg = new protocol.battle_turn_begin();
			msg.player = m_player1.get_id();
			m_player0.sendMsg(msg.data());
			m_player1.sendMsg(msg.data());
		}
	}
	
	public void on_batle_player_shoot(Player player, protocol.battle_player_shoot msg) {
		if(player==m_player0 && m_gameState==GameState.GS_PLAYER0_TURN) {
			m_player0.sendMsg(msg.data());
			m_player1.sendMsg(msg.data());
		}
		else if (player==m_player1 && m_gameState==GameState.GS_PLAYER1_TURN) {		
			m_player0.sendMsg(msg.data());
			m_player1.sendMsg(msg.data());
		}
	}
	
	public void on_batle_switch_turn(Player player) {
		if(player==m_player0 && m_gameState==GameState.GS_PLAYER0_TURN) {
			m_gameState = GameState.GS_PLAYER1_TURN;		
			sendBattleTurnBegin(GameState.GS_PLAYER1_TURN);
		}
		else if (player==m_player1 && m_gameState==GameState.GS_PLAYER1_TURN) {
			m_gameState = GameState.GS_PLAYER0_TURN;
			sendBattleTurnBegin(GameState.GS_PLAYER0_TURN);
		}
	}
}
