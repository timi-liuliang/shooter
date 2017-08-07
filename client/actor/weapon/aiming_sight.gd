extends Node2D

var points = []

func _ready():
	points.append(get_node("sprite_0"))
	points.append(get_node("sprite_1"))
	points.append(get_node("sprite_2"))
	points.append(get_node("sprite_3"))
	points.append(get_node("sprite_4"))
	points.append(get_node("sprite_5"))
	points.append(get_node("sprite_6"))
	points.append(get_node("sprite_7"))
	points.append(get_node("sprite_8"))
	points.append(get_node("sprite_9"))

func set_param(start_pos, init_speed, aim_degree, wind_slow_down, gravity):			
	var delta = 0.015
	for i in range(7):
		# 移动武器
		var shoot_time = i * delta
		var init_dir = Vector2(0,1).rotated(deg2rad(aim_degree + 90))
		var init_velocity = (init_speed - shoot_time * wind_slow_down) * init_dir
		var move_velocity = init_velocity
		move_velocity.y = init_velocity.y + gravity * shoot_time
		start_pos += delta * move_velocity
		points[i].set_pos(start_pos)