extends Node

var player = -1
var name = String()

func _ready():
	pass

func name():
	return 'player_info'

func id():
	return 18

func length():
	return 12 +name.length();

func send(stream):
	var buf = ByteBuf.new()
	buf.write_i32(int(id()))
	buf.write_i32(int(length()))
	buf.write_i64(player)
	buf.write_string(name)
	buf.write_byte(64)
	buf.write_byte(64)
	stream.put_data(buf.raw_data())

func parse_data( byteBuffer):
	player = byteBuffer.read_i64();
	name = byteBuffer.read_string();
	pass
