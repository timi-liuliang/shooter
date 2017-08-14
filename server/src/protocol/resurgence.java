package protocol;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;

public class resurgence extends message {

	public int type = 0;
	@Override

	public int id(){
		 return 12;
	}

	@Override
	public int length(){
		 return 4;
	}

	public ByteBuf data(){
		ByteBuf byteBuffer = Unpooled.buffer(8+length());
		byteBuffer.writeInt(id());
		byteBuffer.writeInt(length());
		byteBuffer.writeInt(type);
		byteBuffer.writeByte(64);
		byteBuffer.writeByte(64);
		return byteBuffer;
	}

	@Override
	public void parse_data(ByteBuf byteBuffer){
		type = byteBuffer.readInt();
	}
}
