extends Node

var start_pos = Vector2(0.0, 0.0)
var aim_degree = float(0.0)
var init_dir = Vector2(0.0, 0.0)
var init_speed = 0.0
var acc_velocity = Vector2(0.0, 0.0)

func _ready():
	pass
	
func set( start, degree, speed, acceleration):
	start_pos = start
	init_speed = speed
	acc_velocity = acceleration
	aim_degree = degree
	init_dir = Vector2(0,1).rotated(deg2rad(aim_degree + 90))
	
func get_pos(shoot_time):
	var offset = init_speed * init_dir * shoot_time + 0.5 * acc_velocity  * shoot_time * shoot_time
	return start_pos + offset
	
func get_velocity(shoot_time):
	return init_speed * init_dir + shoot_time * acc_velocity