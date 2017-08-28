package protocol;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;

public class battle_player_relogin extends message {

	public int battle_time = 0;
	public int player1_blood = 0;
	public long player0 = 0;
	public long player1 = 0;
	public String name0 = "";
	public String name1 = "";
	public int turn_time = 0;
	public long turn_player = 0;
	public int player0_blood = 0;
	public int pos0 = 0;
	public int pos1 = 0;
	@Override

	public int id(){
		 return 7;
	}

	@Override
	public int length(){
		 return 56 +name0.length()+name1.length();
	}

	public ByteBuf data(){
		ByteBuf byteBuffer = Unpooled.buffer(8+length());
		byteBuffer.writeInt(id());
		byteBuffer.writeInt(length());
		byteBuffer.writeInt(battle_time);
		byteBuffer.writeInt(player1_blood);
		byteBuffer.writeLong(player0);
		byteBuffer.writeLong(player1);
		write_string(byteBuffer, name0);
		write_string(byteBuffer, name1);
		byteBuffer.writeInt(turn_time);
		byteBuffer.writeLong(turn_player);
		byteBuffer.writeInt(player0_blood);
		byteBuffer.writeInt(pos0);
		byteBuffer.writeInt(pos1);
		byteBuffer.writeByte(64);
		byteBuffer.writeByte(64);
		return byteBuffer;
	}

	@Override
	public void parse_data(ByteBuf byteBuffer){
		battle_time = byteBuffer.readInt();
		player1_blood = byteBuffer.readInt();
		player0 = byteBuffer.readLong();
		player1 = byteBuffer.readLong();
		name0 = read_string(byteBuffer);
		name1 = read_string(byteBuffer);
		turn_time = byteBuffer.readInt();
		turn_player = byteBuffer.readLong();
		player0_blood = byteBuffer.readInt();
		pos0 = byteBuffer.readInt();
		pos1 = byteBuffer.readInt();
	}
}
