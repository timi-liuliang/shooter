package protocol;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;

public class game_time extends message {

	public int time = 0;
	@Override

	public int id(){
		 return 14;
	}

	@Override
	public int length(){
		 return 4 ;
	}

	public ByteBuf data(){
		ByteBuf byteBuffer = Unpooled.buffer(8+length());
		byteBuffer.writeInt(id());
		byteBuffer.writeInt(length());
		byteBuffer.writeInt(time);
		byteBuffer.writeByte(64);
		byteBuffer.writeByte(64);
		return byteBuffer;
	}

	@Override
	public void parse_data(ByteBuf byteBuffer){
		time = byteBuffer.readInt();
	}
}
