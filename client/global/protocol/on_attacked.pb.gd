extends Node

var damage = int(0)

func _ready():
	pass

func name():
	return 'on_attacked'
func id():
	return 12

func length():
	return 4

func send(stream):
	var buf = ByteBuf.new()
	buf.write_i32(int(id()))
	buf.write_i32(int(length()))
	buf.write_i32(damage)
	buf.write_byte(64)
	buf.write_byte(64)
	stream.put_data(buf.raw_data())

func parse_data( byteBuffer):
	damage = byteBuffer.read_i32();
