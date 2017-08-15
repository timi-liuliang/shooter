extends Node

var item_id = int(0)
var index = int(0)
var item_num = int(0)

func _ready():
	pass

func name():
	return 'backpack_cell'
func id():
	return 1

func length():
	return 12

func send(stream):
	var buf = ByteBuf.new()
	buf.write_i32(int(id()))
	buf.write_i32(int(length()))
	buf.write_i32(item_id)
	buf.write_i32(index)
	buf.write_i32(item_num)
	buf.write_byte(64)
	buf.write_byte(64)
	stream.put_data(buf.raw_data())

func parse_data( byteBuffer):
	item_id = byteBuffer.read_i32();
	index = byteBuffer.read_i32();
	item_num = byteBuffer.read_i32();
