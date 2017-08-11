extends Node2D

var is_inited = false

func _ready():
	set_process(true)
	
func _process(delta):
	if !is_inited:	
		show_games()	
		is_inited = true
		
func show_games():	
	var dir = Directory.new()
	if dir.open("res://apps") == OK:
		dir.list_dir_begin()
		var sub_dir_name = dir.get_next()
		while sub_dir_name != "":
			if dir.current_is_dir() && sub_dir_name!="." && sub_dir_name!="..":
				get_node("game").set_game_name( sub_dir_name)
			
			sub_dir_name = dir.get_next()
			
		dir.list_dir_end()
	else:
		print("An error occured [show_games]")
