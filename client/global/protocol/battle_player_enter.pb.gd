extends Node

var player = -1
var name = String()
var pos = int(0)

func _ready():
	pass

func name():
	return 'battle_player_enter'

func id():
	return 5

func length():
	return 16 +name.length();

func send(stream):
	var buf = ByteBuf.new()
	buf.write_i32(int(id()))
	buf.write_i32(int(length()))
	buf.write_i64(player)
	buf.write_string(name)
	buf.write_i32(pos)
	buf.write_byte(64)
	buf.write_byte(64)
	stream.put_data(buf.raw_data())

func parse_data( byteBuffer):
	player = byteBuffer.read_i64();
	name = byteBuffer.read_string();
	pos = byteBuffer.read_i32();
	pass
