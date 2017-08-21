package protocol;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;

public class battle_player_enter extends message {

	public int pos = 0;
	public String name;
	@Override

	public int id(){
		 return 5;
	}

	@Override
	public int length(){
		 return 8 +name.length();
	}

	public ByteBuf data(){
		ByteBuf byteBuffer = Unpooled.buffer(8+length());
		byteBuffer.writeInt(id());
		byteBuffer.writeInt(length());
		byteBuffer.writeInt(pos);
		write_string(byteBuffer, name);
		byteBuffer.writeByte(64);
		byteBuffer.writeByte(64);
		return byteBuffer;
	}

	@Override
	public void parse_data(ByteBuf byteBuffer){
		pos = byteBuffer.readInt();
		name = read_string(byteBuffer);
	}
}
