extends Node

var osid = String()

func _ready():
	pass

func name():
	return 'login_by_osid'

func id():
	return 19

func length():
	return 4 +osid.length();

func send(stream):
	var buf = ByteBuf.new()
	buf.write_i32(int(id()))
	buf.write_i32(int(length()))
	buf.write_string(osid)
	buf.write_byte(64)
	buf.write_byte(64)
	stream.put_data(buf.raw_data())

func parse_data( byteBuffer):
	osid = byteBuffer.read_string();
	pass
