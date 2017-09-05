package protocol;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;

public class login_by_email extends message {

	public String password = "";
	public String email = "";
	@Override

	public int id(){
		 return 16;
	}

	@Override
	public int length(){
		 return 8 +password.length()+email.length();
	}

	public ByteBuf data(){
		ByteBuf byteBuffer = Unpooled.buffer(8+length());
		byteBuffer.writeInt(id());
		byteBuffer.writeInt(length());
		write_string(byteBuffer, password);
		write_string(byteBuffer, email);
		byteBuffer.writeByte(64);
		byteBuffer.writeByte(64);
		return byteBuffer;
	}

	@Override
	public void parse_data(ByteBuf byteBuffer){
		password = read_string(byteBuffer);
		email = read_string(byteBuffer);
	}
}
