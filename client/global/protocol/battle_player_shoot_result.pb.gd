extends Node

var player1_blood = int(0)
var player0_blood = int(0)

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
	buf.write_i32(player1_blood)
	buf.write_i32(player0_blood)
	buf.write_byte(64)
	buf.write_byte(64)
	stream.put_data(buf.raw_data())

func parse_data( byteBuffer):
	player1_blood = byteBuffer.read_i32();
	player0_blood = byteBuffer.read_i32();
	pass
