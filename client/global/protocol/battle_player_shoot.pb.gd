extends Node

var player = -1
var weapon_pos_x = float(0)
var weapon_pos_y = float(0)
var degree = float(0)

func _ready():
	pass

func name():
	return 'battle_player_shoot'

func id():
	return 6

func length():
	return 20 ;

func send(stream):
	var buf = ByteBuf.new()
	buf.write_i32(int(id()))
	buf.write_i32(int(length()))
	buf.write_i64(player)
	buf.write_float(weapon_pos_x)
	buf.write_float(weapon_pos_y)
	buf.write_float(degree)
	buf.write_byte(64)
	buf.write_byte(64)
	stream.put_data(buf.raw_data())

func parse_data( byteBuffer):
	player = byteBuffer.read_i64();
	weapon_pos_x = byteBuffer.read_float();
	weapon_pos_y = byteBuffer.read_float();
	degree = byteBuffer.read_float();
	pass
