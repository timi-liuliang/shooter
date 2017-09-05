package protocol;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;

public class battle_time extends message {

	public int battle_time = 0;
	public int turn_time = 0;
	@Override

	public int id(){
		 return 12;
	}

	@Override
	public int length(){
		 return 8 ;
	}

	public ByteBuf data(){
		ByteBuf byteBuffer = Unpooled.buffer(8+length());
		byteBuffer.writeInt(id());
		byteBuffer.writeInt(length());
		byteBuffer.writeInt(battle_time);
		byteBuffer.writeInt(turn_time);
		byteBuffer.writeByte(64);
		byteBuffer.writeByte(64);
		return byteBuffer;
	}

	@Override
	public void parse_data(ByteBuf byteBuffer){
		battle_time = byteBuffer.readInt();
		turn_time = byteBuffer.readInt();
	}
}
