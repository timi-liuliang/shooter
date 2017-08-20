extends Control

func _ready():
	pass

func _on_stop_pressed():
	get_node("/root/network").search_room_end()
