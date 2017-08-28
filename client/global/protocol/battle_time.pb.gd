extends Node

var battle_time = int(0)
var turn_time = int(0)

func _ready():
	pass

func name():
	return 'battle_time'

func id():
	return 11

func length():
	return 8 ;

func send(stream):
	var buf = ByteBuf.new()
	buf.write_i32(int(id()))
	buf.write_i32(int(length()))
	buf.write_i32(battle_time)
	buf.write_i32(turn_time)
	buf.write_byte(64)
	buf.write_byte(64)
	stream.put_data(buf.raw_data())

func parse_data( byteBuffer):
	battle_time = byteBuffer.read_i32();
	turn_time = byteBuffer.read_i32();
	pass
