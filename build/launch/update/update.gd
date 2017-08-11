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
	
#func load_dlc():
#	Globals.load_resource_pack("user://dlc/update.pck")	

#func _on_launch_pressed():
	# 实例化全局脚本
#	var global = load("res://global/global.gd").new()
#	global.set_name("global")
#	get_tree().get_root().add_child(global)
