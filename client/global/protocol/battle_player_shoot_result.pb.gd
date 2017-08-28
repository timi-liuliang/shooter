extends Node

var player = -1

func _ready():
	pass

func name():
	return 'battle_player_shoot_result'

func id():
	return 9

func length():
	return 8 ;

func send(stream):
	var buf = ByteBuf.new()
	buf.write_i32(int(id()))
	buf.write_i32(int(length()))
	buf.write_i64(player)
	buf.write_byte(64)
	buf.write_byte(64)
	stream.put_data(buf.raw_data())

func parse_data( byteBuffer):
	player = byteBuffer.read_i64();
	pass
