package protocol;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;

public class max_score extends message {

	public int max_score = 0;
	@Override

	public int id(){
		 return 19;
	}

	@Override
	public int length(){
		 return 4 ;
	}

	public ByteBuf data(){
		ByteBuf byteBuffer = Unpooled.buffer(8+length());
		byteBuffer.writeInt(id());
		byteBuffer.writeInt(length());
		byteBuffer.writeInt(max_score);
		byteBuffer.writeByte(64);
		byteBuffer.writeByte(64);
		return byteBuffer;
	}

	@Override
	public void parse_data(ByteBuf byteBuffer){
		max_score = byteBuffer.readInt();
	}
}
