extends Node

var account = int(0)
var result = int(0)

func _ready():
	pass

func name():
	return 'login_result'

func id():
	return 13

func length():
	return 8 ;

func send(stream):
	var buf = ByteBuf.new()
	buf.write_i32(int(id()))
	buf.write_i32(int(length()))
	buf.write_i32(account)
	buf.write_i32(result)
	buf.write_byte(64)
	buf.write_byte(64)
	stream.put_data(buf.raw_data())

func parse_data( byteBuffer):
	account = byteBuffer.read_i32();
	result = byteBuffer.read_i32();
	pass
