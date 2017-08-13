extends Node2D

var is_inited = false

func _ready():
	set_process(true)
	
func _process(delta):
	if !is_inited:	
		show_games()	
		is_inited = true
		
func show_games():	
	var files = get_node("game").list_files_in_directory("res://apps/")
	for file in files:
		get_node("game").set_game_name( file)
		get_node("game").set_hidden(false)
		print("game [%s] prepare for update." % file)
