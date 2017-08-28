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

import db.db;


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
		port = 8800;
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
				System.out.println(String.format("bind port %d succeed", port));
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
