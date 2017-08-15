extends Control

func _ready():
	pass

func _on_TextureButton_pressed():
	get_node("/root/global").set_scene("res://game_single/game_single.tscn")

func _on_double_money_pressed():
	# ads
	if OS.get_name()=="iOS":
		if(Globals.has_singleton("Gomob")):
			var gomob = Globals.get_singleton("Gomob")
			gomob.show_videoad()


func _on_home_pressed():
	get_node("/root/global").set_scene("res://launch/launch.tscn")
