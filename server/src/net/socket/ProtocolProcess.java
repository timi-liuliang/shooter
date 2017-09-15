package net.socket;

import io.netty.channel.ChannelHandlerContext;
import manager.player.Player;
import manager.ranking.RankingMgr;

interface ProtocolProcess {
	public void on_accept(protocol.message proto, ChannelHandlerContext ctx);
	
	public static void bind() {
		SocketServerHandler.bind(new protocol.register_by_email(), new register_by_email_process());
		SocketServerHandler.bind(new protocol.login_by_email(), new login_by_email_process());
		SocketServerHandler.bind(new protocol.login_by_osid(), new login_by_osid_process());
		SocketServerHandler.bind(new protocol.heart_beat(), new heart_beat_process());
		SocketServerHandler.bind(new protocol.search_room_begin(), new search_room_begin_process());
		SocketServerHandler.bind(new protocol.search_room_end(), new search_room_end_process());
		SocketServerHandler.bind(new protocol.battle_player_shoot(), new battle_player_shoot_process());
		SocketServerHandler.bind(new protocol.battle_switch_turn(), new battle_switch_turn_process());
		SocketServerHandler.bind(new protocol.battle_player_blood(), new battle_player_blood_process());
		SocketServerHandler.bind(new protocol.battle_sync_aim_degree(), new battle_sync_aim_degree_process());
		SocketServerHandler.bind(new protocol.max_score(), new max_score_process());
		SocketServerHandler.bind(new protocol.ranking_request(), new ranking_request_process());
		
		// Unused
		//SocketServerHandler.bind(new protocol.collect_item(), new collect_item_process());
		SocketServerHandler.bind(new protocol.on_attacked(),  new on_attacked_process());
		//SocketServerHandler.bind(new protocol.eat_item(), new eat_item_process());
	}
}

class register_by_email_process implements ProtocolProcess{
	@Override
	public void on_accept(protocol.message proto, ChannelHandlerContext ctx) {
		protocol.register_by_email msg = (protocol.register_by_email)proto;
		
		Player player = Player.get(ctx);
		player.registerByEmail( msg.email, msg.password);
	}
}

class login_by_email_process implements ProtocolProcess{
	@Override
	public void on_accept(protocol.message proto, ChannelHandlerContext ctx) {
		protocol.login_by_email msg = (protocol.login_by_email)proto;	
		
		Player player = Player.get(ctx);
		player.loginByEmail(msg.email, msg.password);
	}
}

class login_by_osid_process implements ProtocolProcess{
	@Override
	public void on_accept(protocol.message proto, ChannelHandlerContext ctx) {
		protocol.login_by_osid msg = (protocol.login_by_osid)proto;	
		
		Player player = Player.get(ctx);
		player.loginByOSID(msg.osid);
	}
}

class heart_beat_process implements ProtocolProcess{
	@Override
	public void on_accept(protocol.message proto, ChannelHandlerContext ctx) {	
		protocol.heart_beat msg = (protocol.heart_beat)proto;	
		Player player = Player.get(ctx);
		player.on_heart_beat(msg.data());
	}
}

class search_room_begin_process implements ProtocolProcess{
	@Override
	public void on_accept(protocol.message proto, ChannelHandlerContext ctx) {	
		Player player = Player.get(ctx);
		player.search_room_begin();
	}
}

class search_room_end_process implements ProtocolProcess{
	@Override
	public void on_accept(protocol.message proto, ChannelHandlerContext ctx) {	
		Player player = Player.get(ctx);
		player.search_room_end();
	}
}

class battle_player_shoot_process implements ProtocolProcess{
	@Override
	public void on_accept(protocol.message proto, ChannelHandlerContext ctx) {	
		Player player = Player.get(ctx);
		protocol.battle_player_shoot msg = (protocol.battle_player_shoot)proto;
		
		player.on_battle_player_shoot(msg);
	}
}

class battle_switch_turn_process implements ProtocolProcess{
	@Override
	public void on_accept(protocol.message proto, ChannelHandlerContext ctx) {	
		Player player = Player.get(ctx);
		protocol.battle_switch_turn msg = (protocol.battle_switch_turn)proto;
		
		player.on_battle_switch_turn();
	}
}

class battle_player_blood_process implements ProtocolProcess{
	@Override
	public void on_accept(protocol.message proto, ChannelHandlerContext ctx) {	
		Player player = Player.get(ctx);
		protocol.battle_player_blood msg = (protocol.battle_player_blood)proto;
		
		player.on_battle_blood_changed(msg);
	}
}

class battle_sync_aim_degree_process implements ProtocolProcess{
	@Override
	public void on_accept(protocol.message proto, ChannelHandlerContext ctx) {	
		Player player = Player.get(ctx);
		protocol.battle_sync_aim_degree msg = (protocol.battle_sync_aim_degree)proto;
		
		player.on_battle_sync_aim_degree(msg);
	}
}

class max_score_process implements ProtocolProcess{
	@Override
	public void on_accept(protocol.message proto, ChannelHandlerContext ctx) {	
		Player player = Player.get(ctx);
		protocol.max_score msg = (protocol.max_score)proto;
		
		player.on_new_max_score(msg);
	}
}

class ranking_request_process implements ProtocolProcess{
	@Override
	public void on_accept(protocol.message proto, ChannelHandlerContext ctx) {		
		RankingMgr.getInstance().onRequestRanking(ctx);
	}
}


class collect_item_process implements ProtocolProcess{
	@Override
	public void on_accept(protocol.message proto, ChannelHandlerContext ctx) {
		//protocol.collect_item msg = (protocol.collect_item)proto;
		
		//Player player = Player.get(ctx);
		//player.collectItem(msg.id, msg.count, msg.type);
	}
}

class on_attacked_process implements ProtocolProcess{
	@Override
	public void on_accept(protocol.message proto, ChannelHandlerContext ctx) {
		protocol.on_attacked msg = (protocol.on_attacked)proto;
		
		Player player = Player.get(ctx);
		player.onAttacked(msg.damage);
	}
}

class eat_item_process implements ProtocolProcess{
	@Override
	public void on_accept(protocol.message proto, ChannelHandlerContext ctx) {
		//protocol.eat_item msg = (protocol.eat_item)proto;
		
		//Player player = Player.get(ctx);
		//player.onEatItem(msg.slot_idx);
	}
}