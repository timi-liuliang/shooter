extends Node

var pos = int(0)
var name = String()

func _ready():
	pass

func name():
	return 'battle_player_enter'
func id():
	return 5

func length():
	return 8 +name.length();

func send(stream):
	var buf = ByteBuf.new()
	buf.write_i32(int(id()))
	buf.write_i32(int(length()))
	buf.write_i32(pos)
	buf.write_string(name)
	buf.write_byte(64)
	buf.write_byte(64)
	stream.put_data(buf.raw_data())

func parse_data( byteBuffer):
	pos = byteBuffer.read_i32();
	name = byteBuffer.read_string();
	pass
