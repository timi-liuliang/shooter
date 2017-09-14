package net.http;

import io.netty.bootstrap.ServerBootstrap;
import io.netty.channel.ChannelHandler;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.ChannelPipeline;
import io.netty.channel.socket.SocketChannel;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.nio.NioServerSocketChannel;

import io.netty.handler.codec.http.HttpObjectAggregator;
import io.netty.handler.codec.http.HttpRequestDecoder;
import io.netty.handler.codec.http.HttpResponseEncoder;
import io.netty.handler.stream.ChunkedWriteHandler;

import java.util.concurrent.Executors;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class HttpServer {
	public static HttpServer inst = null;
	public static int port = 8900;
	private static final Logger logger = LogManager.getLogger("http server");
	private NioEventLoopGroup bossGroup = null;
	private NioEventLoopGroup workGroup = null;
	
	private HttpServer() {
		
	}
	
	public static HttpServer getInstance() {
		if(inst==null) {
			inst = new HttpServer();
			inst.initData();
		}
		
		return inst;
	}
	
	public void initData() {
	}
	
	public void start() {
		bossGroup = new NioEventLoopGroup(0, Executors.newCachedThreadPool());
		workGroup = new NioEventLoopGroup(0, Executors.newCachedThreadPool());
		
		ServerBootstrap bootstrap = new ServerBootstrap();
		bootstrap.group(bossGroup, workGroup);
		bootstrap.channel(NioServerSocketChannel.class);
		
		bootstrap.childHandler(new ChannelInitializer<SocketChannel>() {
			@Override
			protected void initChannel(SocketChannel ch)throws Exception{
				ChannelPipeline pipeline = ch.pipeline();
				
				// http request decoder
				pipeline.addLast("decoder", new HttpRequestDecoder());
				pipeline.addLast("aggregator", new HttpObjectAggregator(65536));
				
				// http response encoder
				pipeline.addLast("encoder", new HttpResponseEncoder());
				pipeline.addLast("http-chunked", new ChunkedWriteHandler());
				pipeline.addLast("inbound",new HttpServerInboundHandler());
			}
		});
		
		bootstrap.bind(port);
		logger.info(String.format("bind port [%d] succeed", port));
	}
	
	public void shut() {
		if(bossGroup!=null && workGroup!=null) {
			bossGroup.shutdownGracefully();
			workGroup.shutdownGracefully();
		}
	}
}
