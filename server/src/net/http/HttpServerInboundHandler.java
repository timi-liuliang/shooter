package net.http;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;
import io.netty.channel.ChannelFutureListener;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;
import io.netty.channel.SimpleChannelInboundHandler;
import io.netty.handler.codec.http.DefaultFullHttpRequest;
import io.netty.handler.codec.http.DefaultFullHttpResponse;
import io.netty.handler.codec.http.DefaultHttpResponse;
import io.netty.handler.codec.http.FullHttpRequest;
import io.netty.handler.codec.http.HttpHeaders;
import io.netty.handler.codec.http.HttpMethod;
import io.netty.handler.codec.http.HttpResponse;
import io.netty.handler.codec.http.HttpResponseStatus;
import io.netty.handler.codec.http.HttpVersion;
import io.netty.handler.codec.http.QueryStringDecoder;
import io.netty.util.CharsetUtil;
import manager.player.Player;
import manager.ranking.RankingMgr;
import manager.room.RoomMgr;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


public class HttpServerInboundHandler extends SimpleChannelInboundHandler<FullHttpRequest>{
	private static final Logger logger = LogManager.getLogger("HttpInHandlerImp");
	
	@Override
	protected void channelRead0(ChannelHandlerContext ctx, FullHttpRequest request) throws Exception {
		if(!request.getDecoderResult().isSuccess()) {
			logger.error("request getDecoderResult() failed");
			return;
		}
		
		if(request.getMethod()==HttpMethod.GET) {
			handleHttpGet(ctx, request);
		}
		else if(request.getMethod()==HttpMethod.POST) {
			handleHttpPost(ctx, request);
		}
	}
	
	private void handleHttpGet(ChannelHandlerContext ctx, FullHttpRequest request) {
		final String uri = request.getUri();
		logger.info("http request[" + uri + "]");
		
		if(uri.equals("/state")) {
			String sendMsg = String.format("Rooms number [%d]\nPlayers number[%d]", RoomMgr.rooms.size(), Player.players.size());

			writeJson(ctx, sendMsg);
		}
		else if(uri.equals("/ranking")) {
			String sendMsg = RankingMgr.getInstance().getRankingInJson();
			
			writeJson(ctx, sendMsg);
		}
		
	}
	
	private void writeJson(ChannelHandlerContext ctx, String sendMsg) {
		ByteBuf content = Unpooled.copiedBuffer(sendMsg, CharsetUtil.UTF_8);
		
		DefaultFullHttpResponse msg = new DefaultFullHttpResponse(HttpVersion.HTTP_1_1, HttpResponseStatus.OK, content);
		msg.headers().set(HttpHeaders.Names.CONTENT_TYPE, "application/json; charset=utf-8");
		msg.headers().set(HttpHeaders.Names.CONTENT_LENGTH, msg.content().readableBytes());
		ctx.write(msg).addListener(ChannelFutureListener.CLOSE);
		ctx.flush();
	}
	
	private void handleHttpPost(ChannelHandlerContext ctx, FullHttpRequest request) {
		
	}
}
