package net;

import io.netty.channel.ChannelHandlerContext;
import player.Player;

interface ProtocolProcess {
	public void on_accept(protocol.message proto, ChannelHandlerContext ctx);
	
	public static void bind() {
		SocketServerHandler.bind(new protocol.register_by_email(), new register_by_email_process());
		SocketServerHandler.bind(new protocol.login_by_email(), new login_by_email_process());
		SocketServerHandler.bind(new protocol.login_by_osid(), new login_by_osid_process());
		SocketServerHandler.bind(new protocol.search_room_begin(), new search_room_begin_process());
		SocketServerHandler.bind(new protocol.search_room_end(), new search_room_end_process());
		
		// Unused
		SocketServerHandler.bind(new protocol.collect_item(), new collect_item_process());
		SocketServerHandler.bind(new protocol.on_attacked(),  new on_attacked_process());
		SocketServerHandler.bind(new protocol.eat_item(), new eat_item_process());
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
		player.sendBattleBegin();
		//player.search_room_end();
	}
}

class collect_item_process implements ProtocolProcess{
	@Override
	public void on_accept(protocol.message proto, ChannelHandlerContext ctx) {
		protocol.collect_item msg = (protocol.collect_item)proto;
		
		Player player = Player.get(ctx);
		player.collectItem(msg.id, msg.count, msg.type);
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
		protocol.eat_item msg = (protocol.eat_item)proto;
		
		Player player = Player.get(ctx);
		player.onEatItem(msg.slot_idx);
	}
}