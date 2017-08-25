package protocol;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;

public class player_base_info extends message {

	public int cur_blood = 0;
	public int max_blood = 0;
	@Override

	public int id(){
		 return 21;
	}

	@Override
	public int length(){
		 return 8 ;
	}

	public ByteBuf data(){
		ByteBuf byteBuffer = Unpooled.buffer(8+length());
		byteBuffer.writeInt(id());
		byteBuffer.writeInt(length());
		byteBuffer.writeInt(cur_blood);
		byteBuffer.writeInt(max_blood);
		byteBuffer.writeByte(64);
		byteBuffer.writeByte(64);
		return byteBuffer;
	}

	@Override
	public void parse_data(ByteBuf byteBuffer){
		cur_blood = byteBuffer.readInt();
		max_blood = byteBuffer.readInt();
	}
}
