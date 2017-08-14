package net;

import java.util.Iterator;
import java.util.Timer;
import java.util.TimerTask;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import io.netty.bootstrap.ServerBootstrap;
import io.netty.buffer.Unpooled;
import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.ChannelOption;
import io.netty.channel.ChannelPipeline;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.nio.NioServerSocketChannel;
import io.netty.channel.socket.SocketChannel;
import io.netty.handler.codec.DelimiterBasedFrameDecoder;


public class SocketServer {
	
	public static SocketServer inst;
	public static int port;
	
	private NioEventLoopGroup bossGroup = new NioEventLoopGroup();
	private NioEventLoopGroup workGroup = new NioEventLoopGroup();
	
	private SocketServer() {
	}
	
	public static SocketServer getInstance(){
		if(inst==null){
			inst = new SocketServer();
			inst.initData();
		}
		
		return inst;
	}
	
	private void initData(){
		port = 8700;
	}
	
	public static void main(String[] args){	
		// 数据保存计时器
		Timer dbSaveTimer = new Timer();
		dbSaveTimer.scheduleAtFixedRate(new TimerTask() {
			@Override
			public void run() {
				player.Player.update();
			}
		}, 5*60*1000, 5*50*1000);
		
		// 启动服务
		SocketServer server = getInstance();
		server.start();
	}

	public void start() {
		ServerBootstrap bootstrap = new ServerBootstrap();
		bootstrap.group(bossGroup, workGroup);
		bootstrap.channel(NioServerSocketChannel.class);
		bootstrap.option(ChannelOption.SO_BACKLOG, 128);
		bootstrap.option(ChannelOption.SO_REUSEADDR, true);
		
		bootstrap.childOption(ChannelOption.SO_KEEPALIVE, true);
		
		bootstrap.childHandler(new ChannelInitializer<SocketChannel>(){
			@Override
			protected void initChannel(SocketChannel ch) throws Exception{
				ChannelPipeline pipeline = ch.pipeline();
				
				ByteBuf delimiter = Unpooled.buffer(2);
				delimiter.writeByte(64);
				delimiter.writeByte(64);
				
				pipeline.addLast(new DelimiterBasedFrameDecoder(1024, true, delimiter));
				pipeline.addLast(new SocketServerHandler());
			}
		});
		
		// start server
		ChannelFuture future;
		try{
			future = bootstrap.bind(port).sync();
			if(future.isSuccess()){
				System.out.println("bind port 8700 succeed");
			}
		}
		catch(InterruptedException e){
			System.out.println("bind port failed");
		}
	}
	
	public void shut(){
		workGroup.shutdownGracefully();
		bossGroup.shutdownGracefully();
	}
}
