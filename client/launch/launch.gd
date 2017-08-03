extends Node2D

func _ready():
	if(Globals.has_singleton("Gomob")):
		print("Gomob")
		var gomob = Globals.get_singleton("Gomob")
		gomob.init("your admob Id")
		gomob.set_test(false)
		gomob.show()
	
	pass

func _on_play_pressed():
	get_node("/root/global").setScene("res://game_single/game_single.tscn")
