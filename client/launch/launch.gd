extends Node2D

func _ready():
	pass

func _on_play_pressed():
	get_node("/root/global").setScene("res://game_single/game_single.tscn")
