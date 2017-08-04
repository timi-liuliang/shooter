extends Node2D

func _ready():
	if(Globals.has_singleton("Gomob")):
		var gomob = Globals.get_singleton("Gomob")
		gomob.init("ca-app-pub-9963645369065369/5009998113")
		gomob.set_test(true)
		gomob.request_videoad()

func _on_play_pressed():
	get_node("/root/global").setScene("res://game_single/game_single.tscn")
