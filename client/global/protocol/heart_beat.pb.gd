extends Node


func _ready():
	pass

func name():
	return 'heart_beat'

func id():
	return 17

func length():
	return 0 ;

func send(stream):
	var buf = ByteBuf.new()
	buf.write_i32(int(id()))
	buf.write_i32(int(length()))
	buf.write_byte(64)
	buf.write_byte(64)
	stream.put_data(buf.raw_data())

func parse_data( byteBuffer):
	pass
