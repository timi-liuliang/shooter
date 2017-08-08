extends Node2D

export(int) var point_num = 8
export(float) var point_scale = 0.2
export(float) var delta = 0.015
var parabola = null

var points = []

func _ready():
	var res = preload("res://actor/aiming/point.tscn")
	for i in range(point_num):
		var point = res.instance()
		point.set_scale(Vector2(point_scale, point_scale))
		points.append(point)
		self.add_child(point)
		
	# 抛物线
	parabola = preload("res://global/parabola.gd").new()

func set_param(start_pos, init_speed, aim_degree, wind_slow_down, gravity):
	parabola.set(start_pos, aim_degree, init_speed, Vector2(-wind_slow_down, gravity))
	for i in range(point_num):
		points[i].set_pos( parabola.get_pos(i*delta))