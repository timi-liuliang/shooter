extends Node

var count = int(0)
var type = int(0)
var id = int(0)

func _ready():
	pass

func name():
	return 'collect_item'
func id():
	return 4

func length():
	return 12 ;

func send(stream):
	var buf = ByteBuf.new()
	buf.write_i32(int(id()))
	buf.write_i32(int(length()))
	buf.write_i32(count)
	buf.write_i32(type)
	buf.write_i32(id)
	buf.write_byte(64)
	buf.write_byte(64)
	stream.put_data(buf.raw_data())

func parse_data( byteBuffer):
	count = byteBuffer.read_i32();
	type = byteBuffer.read_i32();
	id = byteBuffer.read_i32();
	pass
