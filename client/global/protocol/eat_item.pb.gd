extends Node

var slot_idx = int(0)

func _ready():
	pass

func name():
	return 'eat_item'

func id():
	return 14

func length():
	return 4 ;

func send(stream):
	var buf = ByteBuf.new()
	buf.write_i32(int(id()))
	buf.write_i32(int(length()))
	buf.write_i32(slot_idx)
	buf.write_byte(64)
	buf.write_byte(64)
	stream.put_data(buf.raw_data())

func parse_data( byteBuffer):
	slot_idx = byteBuffer.read_i32();
	pass
