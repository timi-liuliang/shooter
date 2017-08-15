extends Node

var num = int(0)

func _ready():
	pass

func name():
	return 'backpack_num'
func id():
	return 2

func length():
	return 4

func send(stream):
	var buf = ByteBuf.new()
	buf.write_i32(int(id()))
	buf.write_i32(int(length()))
	buf.write_i32(num)
	buf.write_byte(64)
	buf.write_byte(64)
	stream.put_data(buf.raw_data())

func parse_data( byteBuffer):
	num = byteBuffer.read_i32();
