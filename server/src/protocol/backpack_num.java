package protocol;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;

public class backpack_num extends message {

	public int num = 0;
	@Override

	public int id(){
		 return 2;
	}

	@Override
	public int length(){
		 return 4 ;
	}

	public ByteBuf data(){
		ByteBuf byteBuffer = Unpooled.buffer(8+length());
		byteBuffer.writeInt(id());
		byteBuffer.writeInt(length());
		byteBuffer.writeInt(num);
		byteBuffer.writeByte(64);
		byteBuffer.writeByte(64);
		return byteBuffer;
	}

	@Override
	public void parse_data(ByteBuf byteBuffer){
		num = byteBuffer.readInt();
	}
}
