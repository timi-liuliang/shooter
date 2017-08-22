extends Control

func _ready():
	pass
	
func set_text(text):
	get_node("display").set_text(text)
	get_node("anim").play("show")
