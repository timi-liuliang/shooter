extends KinematicBody2D

export(int) var player_idx = 0

func _ready():
	pass
	
func set_player_idx(idx):
	player_idx = idx
	
func get_player_idx():
	return player_idx
	
func play_shoot_sound():
	get_node("sound").play("bow_sound")
