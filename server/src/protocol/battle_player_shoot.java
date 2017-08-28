package protocol;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;

public class battle_player_shoot extends message {

	public long player = 0;
	public float weapon_pos_x = 0;
	public float weapon_pos_y = 0;
	public float degree = 0;
	@Override

	public int id(){
		 return 8;
	}

	@Override
	public int length(){
		 return 20 ;
	}

	public ByteBuf data(){
		ByteBuf byteBuffer = Unpooled.buffer(8+length());
		byteBuffer.writeInt(id());
		byteBuffer.writeInt(length());
		byteBuffer.writeLong(player);
		byteBuffer.writeFloat(weapon_pos_x);
		byteBuffer.writeFloat(weapon_pos_y);
		byteBuffer.writeFloat(degree);
		byteBuffer.writeByte(64);
		byteBuffer.writeByte(64);
		return byteBuffer;
	}

	@Override
	public void parse_data(ByteBuf byteBuffer){
		player = byteBuffer.readLong();
		weapon_pos_x = byteBuffer.readFloat();
		weapon_pos_y = byteBuffer.readFloat();
		degree = byteBuffer.readFloat();
	}
}
