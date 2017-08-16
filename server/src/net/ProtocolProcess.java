package net;

import io.netty.channel.ChannelHandlerContext;
import player.Player;

interface ProtocolProcess {
	public void on_accept(protocol.message proto, ChannelHandlerContext ctx);
	
	public static void bind() {
		SocketServerHandler.bind(new protocol.register_by_email(), new register_by_email_process());
		SocketServerHandler.bind(new protocol.login(), new login_process());
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

class login_process implements ProtocolProcess{
	@Override
	public void on_accept(protocol.message proto, ChannelHandlerContext ctx) {
		protocol.login msg = (protocol.login)proto;		
		Player player = Player.get(ctx);
		//player.setAccount("qq79402005", "aqi");
		//player.sendBaseInfo();
		//player.sendBackpackInfo();
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