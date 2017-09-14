package net.socket;

import java.net.InetSocketAddress;
import java.util.HashMap;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import App.app;
import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;
import io.netty.util.ReferenceCountUtil;


class ProtocolInfo{
	public int				id;
	public protocol.message protocol;
	public ProtocolProcess	process;
	
	public ProtocolInfo(int _id, protocol.message msg, ProtocolProcess process){
		id = _id;
		protocol = msg;
		this.process = process;
	}
}

public class SocketServerHandler extends ChannelInboundHandlerAdapter {
	private static final Logger logger = LogManager.getLogger("net");
	public static HashMap<Integer, ProtocolInfo> protocols = new HashMap<Integer, ProtocolInfo>();
	
	public SocketServerHandler() {
		bindProtocols();
	}
	
	@Override
	public void channelRead(ChannelHandlerContext ctx, Object msg){
		try{	
			ByteBuf buff = (ByteBuf)msg;
			while(buff.isReadable()){
				int id = buff.readInt();
				int len = buff.readInt();
				if( protocols.containsKey(id)) {
					ProtocolInfo protoInfo = protocols.get( id);
					protoInfo.protocol.parse_data(buff);
					if(len == protoInfo.protocol.length()) {	
						protoInfo.process.on_accept( protoInfo.protocol, ctx);
					}
					else{
						// 断开链接
						ctx.disconnect();
						logger.info(String.format("proto id [%d] data length is unmatched", id));
					}
				}else {
					// 断开链接
					ctx.disconnect();
					logger.warn(String.format("Unhandled proto id [%d]", id));
				}
			}
		} finally{
			ReferenceCountUtil.release(msg);
		}
	}
	
	@Override
	public void channelReadComplete(ChannelHandlerContext ctx) {
		ctx.flush();
	}
	
    @Override
    public void channelActive(ChannelHandlerContext ctx) throws Exception {	
        ctx.fireChannelActive();
    }
	
	@Override
	public void channelInactive(ChannelHandlerContext ctx)throws Exception {
		// channel失效异常，客户端下线或者强制退出等触发。
		manager.player.Player.disconnectPlayer(ctx);
		
		app.logger().info(String.format("Disconnect from client"));
		
		ctx.fireChannelInactive();
	}
	
	@Override
	public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause){
		// Close the connection when an exception is raised
		cause.printStackTrace();
		ctx.close();
	}
	
	public static void bindProtocols()
	{
		ProtocolProcess.bind();
	}
	
	public static void bind(protocol.message msg, ProtocolProcess func)
	{
		ProtocolInfo info = new ProtocolInfo(msg.id(), msg, func);	
		protocols.put(msg.id(), info);
	}
}
