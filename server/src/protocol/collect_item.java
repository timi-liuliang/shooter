package protocol;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;

public class collect_item extends message {

	public int count = 0;
	public int type = 0;
	public int id = 0;
	@Override

	public int id(){
		 return 4;
	}

	@Override
	public int length(){
		 return 12;
	}

	public ByteBuf data(){
		ByteBuf byteBuffer = Unpooled.buffer(8+length());
		byteBuffer.writeInt(id());
		byteBuffer.writeInt(length());
		byteBuffer.writeInt(count);
		byteBuffer.writeInt(type);
		byteBuffer.writeInt(id);
		byteBuffer.writeByte(64);
		byteBuffer.writeByte(64);
		return byteBuffer;
	}

	@Override
	public void parse_data(ByteBuf byteBuffer){
		count = byteBuffer.readInt();
		type = byteBuffer.readInt();
		id = byteBuffer.readInt();
	}
}
