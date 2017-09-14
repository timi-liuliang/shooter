package net.http;

import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;
import io.netty.handler.codec.http.DefaultFullHttpRequest;
import io.netty.handler.codec.http.DefaultFullHttpResponse;
import io.netty.handler.codec.http.HttpMethod;
import io.netty.handler.codec.http.QueryStringDecoder;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


public class HttpServerInboundHandler extends ChannelInboundHandlerAdapter{
	private static final Logger logger = LogManager.getLogger("HttpInHandlerImp");
	
	public void channelRead(final ChannelHandlerContext ctx, final Object msg) throws Exception {
		logger.info("received msg");
		
		DefaultFullHttpRequest req = (DefaultFullHttpRequest)msg;
		if(req.getMethod() == HttpMethod.GET) {
			handleHttpGet(ctx, req);
		}
		
		if(req.getMethod()==HttpMethod.POST) {
			handleHttpPost(ctx, req);
		}
	}
	
	private void handleHttpGet(final ChannelHandlerContext ctx, DefaultFullHttpRequest req) {
		QueryStringDecoder decoder = new QueryStringDecoder(req.getUri());
		
		logger.error("dfdfdfdfdfdfdfdf");
		
	}
	
	private void handleHttpPost(final ChannelHandlerContext ctx, final DefaultFullHttpRequest req) {
		logger.error("handleHttpPost");
	}
}
