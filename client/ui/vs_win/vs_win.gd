extends Control

func _ready():
	pass

func _on_restart_pressed():
	get_node("/root/global").setScene("res://game_single_vs/game_single_vs.tscn")
