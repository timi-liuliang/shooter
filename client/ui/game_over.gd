extends Control

func _ready():
	pass

func _on_TextureButton_pressed():
	print("nimei")
	get_node("/root/global").setScene("res://game_single/game_single.tscn")
