package protocol;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;

public class backpack_cell extends message {

	public int item_id = 0;
	public int index = 0;
	public int item_num = 0;
	@Override

	public int id(){
		 return 1;
	}

	@Override
	public int length(){
		 return 12 ;
	}

	public ByteBuf data(){
		ByteBuf byteBuffer = Unpooled.buffer(8+length());
		byteBuffer.writeInt(id());
		byteBuffer.writeInt(length());
		byteBuffer.writeInt(item_id);
		byteBuffer.writeInt(index);
		byteBuffer.writeInt(item_num);
		byteBuffer.writeByte(64);
		byteBuffer.writeByte(64);
		return byteBuffer;
	}

	@Override
	public void parse_data(ByteBuf byteBuffer){
		item_id = byteBuffer.readInt();
		index = byteBuffer.readInt();
		item_num = byteBuffer.readInt();
	}
}
