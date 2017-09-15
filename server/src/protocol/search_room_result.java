package protocol;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;

public class search_room_result extends message {

	public int result = 0;
	@Override

	public int id(){
		 return 29;
	}

	@Override
	public int length(){
		 return 4 ;
	}

	public ByteBuf data(){
		ByteBuf byteBuffer = Unpooled.buffer(8+length());
		byteBuffer.writeInt(id());
		byteBuffer.writeInt(length());
		byteBuffer.writeInt(result);
		byteBuffer.writeByte(64);
		byteBuffer.writeByte(64);
		return byteBuffer;
	}

	@Override
	public void parse_data(ByteBuf byteBuffer){
		result = byteBuffer.readInt();
	}
}
