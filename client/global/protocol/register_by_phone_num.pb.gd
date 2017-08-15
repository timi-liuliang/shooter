extends Node

var account = int(0)
var password = int(0)

func _ready():
	pass

func name():
	return 'register_by_phone_num'
func id():
	return 15

func length():
	return 8

func send(stream):
	var buf = ByteBuf.new()
	buf.write_i32(int(id()))
	buf.write_i32(int(length()))
	buf.write_i32(account)
	buf.write_i32(password)
	buf.write_byte(64)
	buf.write_byte(64)
	stream.put_data(buf.raw_data())

func parse_data( byteBuffer):
	account = byteBuffer.read_i32();
	password = byteBuffer.read_i32();
