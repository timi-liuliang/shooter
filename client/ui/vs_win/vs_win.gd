extends Control

func _ready():
	pass

func _on_restart_pressed():
	get_node("/root/global").set_scene("res://game_single_vs/game_single_vs.tscn")
