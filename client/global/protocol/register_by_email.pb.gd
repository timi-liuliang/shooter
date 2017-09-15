extends Node

var password = String()
var email = String()

func _ready():
	pass

func name():
	return 'register_by_email'

func id():
	return 23

func length():
	return 8 +password.length()+email.length();

func send(stream):
	var buf = ByteBuf.new()
	buf.write_i32(int(id()))
	buf.write_i32(int(length()))
	buf.write_string(password)
	buf.write_string(email)
	buf.write_byte(64)
	buf.write_byte(64)
	stream.put_data(buf.raw_data())

func parse_data( byteBuffer):
	password = byteBuffer.read_string();
	email = byteBuffer.read_string();
	pass
