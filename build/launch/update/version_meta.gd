extends Node

var http_domain = ""
var http_url = ""
var pcks = Array()

class PckData:
	var name = ""
	var md5  = ""
	var percent = 0
	
	func _init():
		pass
		
func _ready():
	pass
		
func parse(version_file):
	var parser = XMLParser.new()
	parser.open(version_file)
	while not parser.read():
		if parser.get_node_type()==XMLParser.NODE_ELEMENT and "pck" == parser.get_node_name():
			var item = PckData.new()
			for i in range(parser.get_attribute_count()):
				var att_name = parser.get_attribute_name(i)
				if att_name == "name":
					item.name = parser.get_attribute_value(i)
				elif att_name == "md5":
					item.md5 = parser.get_attribute_value(i)
		
			pcks.append(item)
		elif parser.get_node_type()==XMLParser.NODE_ELEMENT and "pcks" == parser.get_node_name():
			for i in range(parser.get_attribute_count()):
				var att_name = parser.get_attribute_name(i)
				if att_name == "domain":
					http_domain = parser.get_attribute_value(i)
				elif att_name == "url":
					http_url = parser.get_attribute_value(i)
	pass
					
func get_pck_size():
	return pcks.size()
	
func get_pck(idx):
	return pcks[idx]
	
func is_pck_exist(name):
	for i in range(pcks.size()):
		if pcks[i].name == name:
			return true
			
	return false
	
func get_pck_by_name(name):
	for i in range(pcks.size()):
		if pcks[i].name == name:
			return pcks[i]
			
	return null

func get_md5_by_name(name):
	var pck = get_pck_by_name(name)
	if pck:
		return pck.md5
	else:
		return ""
