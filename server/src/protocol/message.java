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

	public void write_string(ByteBuf byteBuffer, String str){
		byteBuffer.writeInt(str.length());
		byteBuffer.writeBytes(str.getBytes());
	}

	public String read_string(ByteBuf byteBuffer){
		int length = byteBuffer.readInt();
		byte[] result = new byte[length];
		for(int i=0; i<length; i++){
			result[i] = byteBuffer.readByte();
		}
		return new String(result);
	}
}
