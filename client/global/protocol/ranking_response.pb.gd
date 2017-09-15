extends Node

var ranking = String()

func _ready():
	pass

func name():
	return 'ranking_response'

func id():
	return 24

func length():
	return 4 +ranking.length();

func send(stream):
	var buf = ByteBuf.new()
	buf.write_i32(int(id()))
	buf.write_i32(int(length()))
	buf.write_string(ranking)
	buf.write_byte(64)
	buf.write_byte(64)
	stream.put_data(buf.raw_data())

func parse_data( byteBuffer):
	ranking = byteBuffer.read_string();
	pass
