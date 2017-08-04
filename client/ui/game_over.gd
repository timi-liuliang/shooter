extends Control

func _ready():
	pass

func _on_TextureButton_pressed():
	# ads
	if OS.get_name()=="iOS":
		if(Globals.has_singleton("Gomob")):
			print("Gomob")
			var gomob = Globals.get_singleton("Gomob")
			gomob.init("your admob Id")
			gomob.set_test(true)
			gomob.show()	
	
	get_node("/root/global").setScene("res://game_single/game_single.tscn")
