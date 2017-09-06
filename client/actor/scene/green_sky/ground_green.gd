extends Node2D

var last_center_idx = int(0);

func _ready():
	set_process(true)

func _process(delta):
	var camera = Globals.get("main_camera")
	var pos = camera.get_pos()
	var center_idx = int(pos.x / 1024.0)
	if center_idx != last_center_idx:
		var center_pos_x = center_idx * 1024.0
		get_node("Sprite_0").set_pos(Vector2( center_pos_x - 2560, 0.0))
		get_node("Sprite_1").set_pos(Vector2( center_pos_x - 1536, 0.0))
		get_node("Sprite_2").set_pos(Vector2( center_pos_x - 512, 0.0))
		get_node("Sprite_3").set_pos(Vector2( center_pos_x + 512, 0.0))
		get_node("Sprite_4").set_pos(Vector2( center_pos_x + 1536, 0.0))
		get_node("Sprite_5").set_pos(Vector2( center_pos_x + 2560, 0.0))
		
		last_center_idx = center_idx
