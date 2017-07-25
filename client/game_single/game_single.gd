extends Node2D

var is_aim    = false
var aim_degree = 0.0
var aim_adjust_dir = 1.0
var is_shoot = false
var shoot_time = 0.0
export(float) var init_speed = 300
export(float)   var gravity = 100

func _ready():
	set_process(true)
	set_fixed_process(true)
	
func _process(delta):
	if Input.is_action_pressed("touch"):
		var weapon = get_node("arrow")
		aim_degree += delta * 60.0 * aim_adjust_dir
		if aim_degree > 89.0:
			aim_adjust_dir = -1.0
		if aim_degree <0.0:
			aim_adjust_dir = 1.0
			
		weapon.set_rot(deg2rad(aim_degree + 90))
		
		is_aim = true
		
	if (not Input.is_action_pressed("touch")) and is_aim:
		is_shoot = true

func _fixed_process(delta):
	var weapon = get_node("arrow")
	if is_shoot and not weapon.is_colliding():
		shoot_time += delta
		
		var init_dir = Vector2(0,1).rotated(deg2rad(aim_degree + 90))
		var init_velocity = init_speed * init_dir#.rotated()
		var move_velocity = init_velocity
		move_velocity.y = init_velocity.y + gravity * shoot_time
		
		weapon.move( delta * move_velocity)
		var velocity = move_velocity
		velocity = velocity.normalized()
		var angle = Vector2(0.0, 1.0).angle_to(velocity)
		weapon.set_rot(angle)
		
	if weapon.is_colliding():
		print("diaodiaodiao")
