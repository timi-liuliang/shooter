extends Node

var items = Array()

class Item:
	var id = 0
	var name = String("")
	var type = String("")
	var icon = String("")
	var res  = String("")
	var res_load = null
	var is_can_eat = false
	var add_blood = 0
	
	func _init():
		pass

func _ready():
	var parser = XMLParser.new()
	parser.open("res://global/cfg/items.xml")
	while not parser.read():
		if parser.get_node_type()==XMLParser.NODE_ELEMENT and "item" == parser.get_node_name():
			var item = Item.new()
			for i in range(parser.get_attribute_count()):
				var att_name = parser.get_attribute_name(i)
				if att_name == "id":
					item.id = parser.get_attribute_value(i).to_int()
				elif att_name == "name":
					item.name = parser.get_attribute_value(i)
				elif att_name == "type":
					item.type = parser.get_attribute_value(i)
				elif att_name == "icon":
					item.icon = parser.get_attribute_value(i)
				elif att_name == "res":
					item.res = parser.get_attribute_value(i)
					item.res_load = load(item.res)
				elif att_name == "is_can_eat":
					item.is_can_eat = bool(parser.get_attribute_value(i).to_int())
				elif att_name == "add_blood":
					item.add_blood = parser.get_attribute_value(i).to_int()
		
			items.append(item)
	
func get_item_count():
	return items.size()
	
func get_item_by_index( idx):
	return items[idx]
	
func get_item_by_id(id):
	for item in items:
		if item.id == id:
			return item
			
	return null

func get_item_icon( id):
	for item in items:
		if item.id == id:
			var tex  = load(item.icon)
			print(item.icon)
			return tex
	
	get_node("/root/logger").error("Can not find icon by item id")
	return null

	
	
