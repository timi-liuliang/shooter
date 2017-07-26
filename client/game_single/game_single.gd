extends Node2D

var is_aim    = false
var aim_degree = 0.0
var aim_adjust_dir = 1.0
var is_shoot = false
var shoot_time = 0.0
export(float) var init_speed = 300
export(float)   var gravity = 100

export(float) var character_move_speed = 100

const CREAT_NEXT_BATTLE_MAP = 1
const MOVETO_NEXT_BATTLE_MAP = 2
const DELETE_LAST_BATTLE_MAP = 3
var   next_battle_pos = Vector2()

var is_weapon_colling = false

var gen_map_phase = 0

var battle_id = int(0)

func _ready():
	set_process(true)
	set_fixed_process(true)
	
func _process(delta):
	if Input.is_action_pressed("touch") and not is_shoot:
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
		
	refresh_map(delta)

func _fixed_process(delta):
	var weapon = get_node("arrow")
	var is_c = weapon.is_colliding()
	if is_shoot and not weapon.is_colliding():
		shoot_time += delta
		
		var init_dir = Vector2(0,1).rotated(deg2rad(aim_degree + 90))
		var init_velocity = init_speed * init_dir
		var move_velocity = init_velocity
		move_velocity.y = init_velocity.y + gravity * shoot_time
		
		print("hihi")
		
		weapon.move( delta * move_velocity)
		var velocity = move_velocity
		velocity = velocity.normalized()
		var angle = Vector2(0.0, 1.0).angle_to(velocity)
		weapon.set_rot(angle)
		
	if weapon.is_colliding() and not is_weapon_colling:
		var collider = weapon.get_collider()
		if collider.get_type()=="body":
			print("body shooter")
			gen_map_phase = CREAT_NEXT_BATTLE_MAP
		elif collider.get_type()=="head":
			gen_map_phase = CREAT_NEXT_BATTLE_MAP
			print("head shooter")
		else:
			print("fail")
	
	is_weapon_colling = weapon.is_colliding()

func refresh_map(delta):
	if gen_map_phase == CREAT_NEXT_BATTLE_MAP:
		var next_battle_id = battle_id + 1
		var ground = preload("res://actor/ground/ground.tscn").instance()
		ground.set_battle_id(next_battle_id)
		ground.set_pos(Vector2( next_battle_id * 1334, 712))
		get_node("ground").add_child(ground)
		next_battle_pos = Vector2(next_battle_id * 1334 + randi() % 100, 644)
		
		# gen column enemy
		var column = preload("res://actor/column/column_0.tscn").instance()
		column.set_battle_id(next_battle_id)
		column.set_pos(Vector2( next_battle_id * 1334 + 200 + randi() % 9 * 100, 750 - randi() % 6 * 100))
		get_node("column_enemy").add_child(column)
		
		gen_map_phase = MOVETO_NEXT_BATTLE_MAP
		
	if gen_map_phase == MOVETO_NEXT_BATTLE_MAP:
		var character = get_node("archer")
		var cur_pos = character.get_pos()
		if cur_pos.x != next_battle_pos.x:
			var len = next_battle_pos.x - cur_pos.x
			var move_len = min(len, character_move_speed*delta)
			var next_pos = cur_pos + Vector2(move_len, 0.0)
			character.set_pos( next_pos)
		else:
			var character = get_node("archer")
			var cur_pos = character.get_pos()
			get_node("arrow").free()
			
			var arrow = preload("res://actor/weapon/arrow.tscn").instance()
			self.add_child(arrow)
			
			get_node("arrow").set_pos(cur_pos + Vector2(80, -80))
			get_node("arrow").set_scale(Vector2(3.0, 2.9))
			get_node("arrow").set_rot(deg2rad(90.0))
			is_aim = false
			is_shoot = false
			shoot_time = 0.0
			aim_degree = 0.0
			gen_map_phase = DELETE_LAST_BATTLE_MAP
			
	if gen_map_phase == DELETE_LAST_BATTLE_MAP:
		var ground = get_node("ground")
		for i in range(ground.get_child_count()):
			var child = ground.get_child(i)
			if child.get_battle_id()==battle_id:
				child.queue_free()
				
		var column_enemy = get_node("column_enemy")
		for i in range(column_enemy.get_child_count()):
			var child = column_enemy.get_child(i)
			if child.get_battle_id()==battle_id:
				child.queue_free()
		
		battle_id = battle_id+1
		gen_map_phase = 0
