package protocol;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;

public class battle_sync_aim_degree extends message {

	public float aim_degree = 0;
	@Override

	public int id(){
		 return 11;
	}

	@Override
	public int length(){
		 return 4 ;
	}

	public ByteBuf data(){
		ByteBuf byteBuffer = Unpooled.buffer(8+length());
		byteBuffer.writeInt(id());
		byteBuffer.writeInt(length());
		byteBuffer.writeFloat(aim_degree);
		byteBuffer.writeByte(64);
		byteBuffer.writeByte(64);
		return byteBuffer;
	}

	@Override
	public void parse_data(ByteBuf byteBuffer){
		aim_degree = byteBuffer.readFloat();
	}
}
