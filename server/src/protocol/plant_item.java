package protocol;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;

public class plant_item extends message {

	public float pos_z = 0;
	public float pos_x = 0;
	public float pos_y = 0;
	public int slot_idx = 0;
	@Override

	public int id(){
		 return 10;
	}

	@Override
	public int length(){
		 return 16;
	}

	public ByteBuf data(){
		ByteBuf byteBuffer = Unpooled.buffer(8+length());
		byteBuffer.writeInt(id());
		byteBuffer.writeInt(length());
		byteBuffer.writeFloat(pos_z);
		byteBuffer.writeFloat(pos_x);
		byteBuffer.writeFloat(pos_y);
		byteBuffer.writeInt(slot_idx);
		byteBuffer.writeByte(64);
		byteBuffer.writeByte(64);
		return byteBuffer;
	}

	@Override
	public void parse_data(ByteBuf byteBuffer){
		pos_z = byteBuffer.readFloat();
		pos_x = byteBuffer.readFloat();
		pos_y = byteBuffer.readFloat();
		slot_idx = byteBuffer.readInt();
	}
}
