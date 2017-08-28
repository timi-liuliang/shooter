extends Node

var battle_time = int(0)
var player1_blood = int(0)
var player0 = -1
var player1 = -1
var name0 = String()
var name1 = String()
var turn_time = int(0)
var turn_player = -1
var player0_blood = int(0)
var pos0 = int(0)
var pos1 = int(0)

func _ready():
	pass

func name():
	return 'battle_player_relogin'

func id():
	return 7

func length():
	return 56 +name0.length()+name1.length();

func send(stream):
	var buf = ByteBuf.new()
	buf.write_i32(int(id()))
	buf.write_i32(int(length()))
	buf.write_i32(battle_time)
	buf.write_i32(player1_blood)
	buf.write_i64(player0)
	buf.write_i64(player1)
	buf.write_string(name0)
	buf.write_string(name1)
	buf.write_i32(turn_time)
	buf.write_i64(turn_player)
	buf.write_i32(player0_blood)
	buf.write_i32(pos0)
	buf.write_i32(pos1)
	buf.write_byte(64)
	buf.write_byte(64)
	stream.put_data(buf.raw_data())

func parse_data( byteBuffer):
	battle_time = byteBuffer.read_i32();
	player1_blood = byteBuffer.read_i32();
	player0 = byteBuffer.read_i64();
	player1 = byteBuffer.read_i64();
	name0 = byteBuffer.read_string();
	name1 = byteBuffer.read_string();
	turn_time = byteBuffer.read_i32();
	turn_player = byteBuffer.read_i64();
	player0_blood = byteBuffer.read_i32();
	pos0 = byteBuffer.read_i32();
	pos1 = byteBuffer.read_i32();
	pass
