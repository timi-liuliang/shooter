package protocol;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;

public class on_attacked extends message {

	public int damage = 0;
	@Override

	public int id(){
		 return 20;
	}

	@Override
	public int length(){
		 return 4 ;
	}

	public ByteBuf data(){
		ByteBuf byteBuffer = Unpooled.buffer(8+length());
		byteBuffer.writeInt(id());
		byteBuffer.writeInt(length());
		byteBuffer.writeInt(damage);
		byteBuffer.writeByte(64);
		byteBuffer.writeByte(64);
		return byteBuffer;
	}

	@Override
	public void parse_data(ByteBuf byteBuffer){
		damage = byteBuffer.readInt();
	}
}
