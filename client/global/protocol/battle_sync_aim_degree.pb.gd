extends Node

var aim_degree = float(0)

func _ready():
	pass

func name():
	return 'battle_sync_aim_degree'

func id():
	return 11

func length():
	return 4 ;

func send(stream):
	var buf = ByteBuf.new()
	buf.write_i32(int(id()))
	buf.write_i32(int(length()))
	buf.write_float(aim_degree)
	buf.write_byte(64)
	buf.write_byte(64)
	stream.put_data(buf.raw_data())

func parse_data( byteBuffer):
	aim_degree = byteBuffer.read_float();
	pass
