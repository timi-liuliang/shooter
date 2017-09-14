package net.http;

import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;
import io.netty.channel.SimpleChannelInboundHandler;
import io.netty.handler.codec.http.DefaultFullHttpRequest;
import io.netty.handler.codec.http.DefaultFullHttpResponse;
import io.netty.handler.codec.http.FullHttpRequest;
import io.netty.handler.codec.http.HttpMethod;
import io.netty.handler.codec.http.QueryStringDecoder;

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
		logger.info(uri);
	}
	
	private void handleHttpPost(ChannelHandlerContext ctx, FullHttpRequest request) {
		
	}
}
