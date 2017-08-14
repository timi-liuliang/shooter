package protocol;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;

public class plant_item_reply extends message {

	public int item_id = 0;
	public float pos_z = 0;
	public float pos_x = 0;
	public float pos_y = 0;
	@Override

	public int id(){
		 return 11;
	}

	@Override
	public int length(){
		 return 16;
	}

	public ByteBuf data(){
		ByteBuf byteBuffer = Unpooled.buffer(8+length());
		byteBuffer.writeInt(id());
		byteBuffer.writeInt(length());
		byteBuffer.writeInt(item_id);
		byteBuffer.writeFloat(pos_z);
		byteBuffer.writeFloat(pos_x);
		byteBuffer.writeFloat(pos_y);
		byteBuffer.writeByte(64);
		byteBuffer.writeByte(64);
		return byteBuffer;
	}

	@Override
	public void parse_data(ByteBuf byteBuffer){
		item_id = byteBuffer.readInt();
		pos_z = byteBuffer.readFloat();
		pos_x = byteBuffer.readFloat();
		pos_y = byteBuffer.readFloat();
	}
}
