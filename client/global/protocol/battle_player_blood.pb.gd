extends Node

var blood = int(0)

func _ready():
	pass

func name():
	return 'battle_player_blood'

func id():
	return 5

func length():
	return 4 ;

func send(stream):
	var buf = ByteBuf.new()
	buf.write_i32(int(id()))
	buf.write_i32(int(length()))
	buf.write_i32(blood)
	buf.write_byte(64)
	buf.write_byte(64)
	stream.put_data(buf.raw_data())

func parse_data( byteBuffer):
	blood = byteBuffer.read_i32();
	pass
