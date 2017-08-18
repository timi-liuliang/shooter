package protocol;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;

public class login_by_email extends message {

	public int password = 0;
	public String email;
	@Override

	public int id(){
		 return 7;
	}

	@Override
	public int length(){
		 return 8 +email.length();
	}

	public ByteBuf data(){
		ByteBuf byteBuffer = Unpooled.buffer(8+length());
		byteBuffer.writeInt(id());
		byteBuffer.writeInt(length());
		byteBuffer.writeInt(password);
		write_string(byteBuffer, email);
		byteBuffer.writeByte(64);
		byteBuffer.writeByte(64);
		return byteBuffer;
	}

	@Override
	public void parse_data(ByteBuf byteBuffer){
		password = byteBuffer.readInt();
		email = read_string(byteBuffer);
	}
}
