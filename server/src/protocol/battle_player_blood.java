package protocol;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;

public class battle_player_blood extends message {

	public int self_blood = 0;
	public int enemy_blood = 0;
	@Override

	public int id(){
		 return 5;
	}

	@Override
	public int length(){
		 return 8 ;
	}

	public ByteBuf data(){
		ByteBuf byteBuffer = Unpooled.buffer(8+length());
		byteBuffer.writeInt(id());
		byteBuffer.writeInt(length());
		byteBuffer.writeInt(self_blood);
		byteBuffer.writeInt(enemy_blood);
		byteBuffer.writeByte(64);
		byteBuffer.writeByte(64);
		return byteBuffer;
	}

	@Override
	public void parse_data(ByteBuf byteBuffer){
		self_blood = byteBuffer.readInt();
		enemy_blood = byteBuffer.readInt();
	}
}
