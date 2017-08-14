package protocol;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;

public class message {

	public int id(){
		 return 0;
	}

	public int length(){
		 return 0;
	}

	public void parse_data(ByteBuf byteBuffer){
		System.out.println("parse_data method hasn't implementation.");
	}
}
