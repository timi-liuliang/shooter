extends Node

var max_score = int(0)

func _ready():
	pass

func name():
	return 'max_score'

func id():
	return 19

func length():
	return 4 ;

func send(stream):
	var buf = ByteBuf.new()
	buf.write_i32(int(id()))
	buf.write_i32(int(length()))
	buf.write_i32(max_score)
	buf.write_byte(64)
	buf.write_byte(64)
	stream.put_data(buf.raw_data())

func parse_data( byteBuffer):
	max_score = byteBuffer.read_i32();
	pass
