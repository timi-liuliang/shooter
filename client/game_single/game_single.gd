extends Node2D

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	
func _input(event):
	if Input.is_action_pressed("touch"):
		var weapon = get_node("arrow")
		weapon.set_gravity_scale(1.0)
		weapon.set_linear_velocity(Vector2(300, -300))


func _fixed_process(delta):
	var weapon = get_node("arrow")
	var velocity = weapon.get_linear_velocity()
	if velocity.length_squared() > 0.0:
		velocity = velocity.normalized()
		var angle = velocity.angle_to(Vector2(-1.0, 0.0))
		weapon.set_rot( angle)
		
	#if weapon.get_colliding_bodies().size() > 0 :
	#	weapon.set_linear_velocity(Vector2(0, 0))
	#	weapon.set_gravity_scale(0.0)
	#	print("dfdfdfd")