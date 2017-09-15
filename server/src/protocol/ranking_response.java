package protocol;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;

public class ranking_response extends message {

	public String ranking = "";
	@Override

	public int id(){
		 return 24;
	}

	@Override
	public int length(){
		 return 4 +ranking.length();
	}

	public ByteBuf data(){
		ByteBuf byteBuffer = Unpooled.buffer(8+length());
		byteBuffer.writeInt(id());
		byteBuffer.writeInt(length());
		write_string(byteBuffer, ranking);
		byteBuffer.writeByte(64);
		byteBuffer.writeByte(64);
		return byteBuffer;
	}

	@Override
	public void parse_data(ByteBuf byteBuffer){
		ranking = read_string(byteBuffer);
	}
}
