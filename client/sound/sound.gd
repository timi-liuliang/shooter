extends Node2D

func _ready():
	pass
	
func play_music():
	get_node("music").play("bg_music_0", 0.5)

func play_sound(sound):
	get_node("sound").play(sound)