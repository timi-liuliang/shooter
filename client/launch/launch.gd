extends Node2D

func _ready():
	set_process(true)
	
func _process(delta):
	if !has_node("/root/global"):
		var global = preload("res://global/global.gd").new()
		global.set_name("global")
		get_tree().get_root().add_child(global)

func _on_play_pressed():
	get_node("/root/global").set_scene("res://game_single/game_single.tscn")

func _on_wechat_pressed():
	get_node("/root/wechat").send_msg()

func _on_vs_pressed():
	get_node("/root/global").set_scene("res://game_single_vs/game_single_vs.tscn")
