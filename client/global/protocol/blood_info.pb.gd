extends Node

var cur_blood = int(0)
var max_blood = int(0)

func _ready():
	pass

func name():
	return 'blood_info'
func id():
	return 3

func length():
	return 8

func send(stream):
	var buf = ByteBuf.new()
	buf.write_i32(int(id()))
	buf.write_i32(int(length()))
	buf.write_i32(cur_blood)
	buf.write_i32(max_blood)
	buf.write_byte(64)
	buf.write_byte(64)
	stream.put_data(buf.raw_data())

func parse_data( byteBuffer):
	cur_blood = byteBuffer.read_i32();
	max_blood = byteBuffer.read_i32();
