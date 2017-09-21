extends Node2D
	
func on_attack():
	get_node("sound").play("man_wound")
