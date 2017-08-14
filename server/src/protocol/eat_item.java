package protocol;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;

public class eat_item extends message {

	public int slot_idx = 0;
	@Override

	public int id(){
		 return 6;
	}

	@Override
	public int length(){
		 return 4;
	}

	public ByteBuf data(){
		ByteBuf byteBuffer = Unpooled.buffer(8+length());
		byteBuffer.writeInt(id());
		byteBuffer.writeInt(length());
		byteBuffer.writeInt(slot_idx);
		byteBuffer.writeByte(64);
		byteBuffer.writeByte(64);
		return byteBuffer;
	}

	@Override
	public void parse_data(ByteBuf byteBuffer){
		slot_idx = byteBuffer.readInt();
	}
}
