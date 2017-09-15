extends Node2D

func _ready():
	set_process(true)
	
func _process(delta):
	if !has_node("/root/global"):
		var global = load("res://global/global.gd").new()
		global.set_name("global")
		get_tree().get_root().add_child(global)
		
		update_coin_num_display()
	
func update_coin_num_display():
	var data = get_node("/root/player")
	get_node("ui/common/jinbi/Label").set_text(String(data.get_coin_num()))
	
func on_loaded_rakinglist(msg):
	var dict = {}
	if(dict.parse_json(msg.ranking)==OK):
		get_node("ui/main").set_hidden(true)
		get_node("ui/ranking").set_hidden(false)
		get_node("ui/ranking").refresh_display(dict)
	else:
		print("Dictionary parse failed")

