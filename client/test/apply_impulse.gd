extends Node2D

func _ready():
	set_process_input(true)
	var mask = get_node("StaticBody2D").get_collision_mask()
	var layer = get_node("StaticBody2D").get_collision_
	var b = 3.0
	
	
func _input(event):
	if Input.is_action_pressed("touch"):
		if event.pos.x > get_node("enemy").get_pos().x:
			get_node("enemy").apply_impulse( event.pos - get_node("enemy").get_pos(), Vector2(-1.0, 0.0) * 100)
		else:
			get_node("enemy").apply_impulse( event.pos - get_node("enemy").get_pos(), Vector2(1.0, 0.0) * 100)
		
		
