extends Node

var password = int(0)
var email = String()

func _ready():
	pass

func name():
	return 'login_by_email'
func id():
	return 7

func length():
	return 8 +email.length();

func send(stream):
	var buf = ByteBuf.new()
	buf.write_i32(int(id()))
	buf.write_i32(int(length()))
	buf.write_i32(password)
	buf.write_string(email)
	buf.write_byte(64)
	buf.write_byte(64)
	stream.put_data(buf.raw_data())

func parse_data( byteBuffer):
	password = byteBuffer.read_i32();
	email = byteBuffer.read_string();
