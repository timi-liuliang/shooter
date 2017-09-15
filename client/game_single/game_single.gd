extends Node2D

enum GameState{
	GS_PREPARE,
	GS_AIM,
	GS_SHOOT,
	GS_CHECK_SHOOT_RESULT,
	GS_CREATE_NEXT_BATTLE_MAP,
	GS_MOVETO_NEXT_BATTLE_MAP,
	GS_DELETE_LAST_BATTLE_MAP,
	GS_Failing,
	GS_Failed
}

var parabola = null
var game_state =GameState.GS_CREATE_NEXT_BATTLE_MAP
var score = int(0)
var cam_archer_offset
var cam_arrow_offset
var aim_degree = 0.0
var aim_adjust_dir = 1.0
var shoot_time = 0.0
export(float) var init_speed = 300
export(float) var gravity = 100
export(float) var character_move_speed = 100
export(float) var wind_slow_down = 100
var next_battle_pos = Vector2()
var column_pos = Vector2()
var battle_id = int(0)
var blood_effect = null
var continue_head_shot_num = 0

func _ready():
	var camera = get_node("camera")
	Globals.set("main_camera", camera)
	
	# 设置碰撞标记
	get_node("archer").disable_collision()
	
	# 抛物线
	parabola = preload("res://global/parabola.gd").new()
	
	cam_archer_offset = get_node("camera").get_pos() - get_node("archer").get_pos()
	cam_arrow_offset  = get_node("camera").get_pos() - get_node("archer").get_pos()
	
	# request ad
	if(Globals.has_singleton("Gomob")):
		var gomob = Globals.get_singleton("Gomob")
		gomob.request_videoad()
		
	# 金币数量
	var coin_num = get_node("/root/player").get_coin_num()
	get_node("ui/coin").set_text(String(coin_num))
	
	set_process(true)
	
func _process(delta):
	if game_state == GameState.GS_PREPARE:
		prepare()
	elif game_state == GameState.GS_AIM:
		aim(delta)
	elif game_state == GameState.GS_SHOOT:
		shoot(delta)
	elif game_state == GameState.GS_CHECK_SHOOT_RESULT:
		check_result()
	elif game_state == GameState.GS_CREATE_NEXT_BATTLE_MAP:
		create_next_battle_map()
	elif game_state == GameState.GS_MOVETO_NEXT_BATTLE_MAP:
		moveto_next_battle_map(delta)
	elif game_state == GameState.GS_DELETE_LAST_BATTLE_MAP:
		delete_last_battle_map()
	elif game_state == GameState.GS_Failing:
		failing()
	elif game_state == GameState.GS_Failed:
		failed()
	
func prepare():
	if Input.is_action_pressed("touch"):
		game_state = GameState.GS_AIM
		
	var character = get_node("archer")
	character.set_hand_rot(deg2rad(aim_degree))
	character.play_anim("idle")
		
	var weapon = get_node("weapon/arrow")
	weapon.set_pos(character.get_weapon_pos())
	weapon.set_rot(character.get_weapon_rot())
	
func aim(delta):
	if Input.is_action_pressed("touch"):	
		aim_degree += delta * 60.0 * aim_adjust_dir
		if aim_degree > 89.0:
			aim_adjust_dir = -1.0
		if aim_degree <0.0:
			aim_adjust_dir = 1.0
			
		var character = get_node("archer")
		character.set_hand_rot(deg2rad(aim_degree))
		
		var weapon = get_node("weapon/arrow")
		weapon.set_pos(character.get_weapon_pos())
		weapon.set_rot(character.get_weapon_rot())
		var weapon_head_pos = weapon.get_node("display/head").get_global_pos()
		
		# show aiming
		get_node("aiming_sight").set_hidden(false)
		get_node("aiming_sight").set_param(weapon_head_pos, init_speed, aim_degree, wind_slow_down, gravity)
		
	if !Input.is_action_pressed("touch"):
		var character = get_node("archer")
		get_node("weapon/arrow").set_hidden(false)
		get_node("aiming_sight").set_hidden(true)
		
		# 抛物线
		var weapon = get_node("weapon/arrow")
		parabola.set(weapon.get_pos(), aim_degree, init_speed, Vector2(-wind_slow_down, gravity))
		
		game_state = GameState.GS_SHOOT
		
func shoot(delta):
	var weapon = get_node("weapon/arrow")
	var cha_pos = get_node("archer").get_pos()
	if !weapon.is_colliding():
		# 移动武器
		shoot_time += delta
		var offset = parabola.get_pos(shoot_time) - weapon.get_pos()
		weapon.move(offset)
		
		#  纠正武器朝向
		var velocity = parabola.get_velocity(shoot_time)
		velocity = velocity.normalized()
		var angle = Vector2(0.0, 1.0).angle_to(velocity)
		weapon.set_rot(angle)
		
		# 摄像机跟随武器
		if weapon.get_pos().x < cha_pos.x + 924:
			var camera = get_node("camera")
			var cam_cur_pos = camera.get_pos()
			var cam_target_pos = weapon.get_pos() + cam_arrow_offset * 0.2
			var next_target_pos = (cam_target_pos - cam_cur_pos) * 0.1 + cam_cur_pos
			var cam_target_zoom = Vector2(max(1.0-shoot_time*0.2, 0.5), max(1.0-shoot_time*0.2, 0.5))
			var next_zoom = camera.get_zoom() + (cam_target_zoom - camera.get_zoom()) * 0.05
			next_target_pos.y = max(next_target_pos.y, 128.0)
			camera.set_pos( next_target_pos)
			camera.set_zoom(next_zoom)
			
		# 回复射击初始姿势
		var character = get_node("archer")
		var cha_hand_rot = character.get_hand_rot()
		cha_hand_rot = max( 0.0, cha_hand_rot - delta* 10)
		character.set_hand_rot( cha_hand_rot)
		
	var arrow_pos_x = weapon.get_pos().x	
	if weapon.is_colliding() || arrow_pos_x > (cha_pos.x + 1124):
		game_state = GameState.GS_CHECK_SHOOT_RESULT	
		
func check_result():
	var weapon = get_node("weapon/arrow")
	if weapon.is_colliding():
		var collider = weapon.get_collider()
		# 施加力
		if collider.is_type("RigidBody2D"):	
			var impulse = Vector2(0.0, 1.0)
			impulse = impulse.rotated(weapon.get_rot())
			
			var weapon_display = weapon.get_node("display")
			weapon.remove_child(weapon_display)		
			collider.add_child(weapon_display)
			var offset = weapon.get_collision_pos() - collider.get_global_pos()
			collider.apply_impulse( offset, impulse * 150.0)
			
			weapon.set_layer_mask(4)
			weapon.set_collision_mask(4)
		
		# 计算得分
		if collider.get_type()=="body" || collider.get_type()=="head":
			# 显示血
			if blood_effect:
				blood_effect.queue_free()
				blood_effect = null
			
			blood_effect = preload("res://effect/blood.tscn").instance()
			blood_effect.set_pos( weapon.get_collision_pos())
			blood_effect.set_rot( weapon.get_rot())
			blood_effect.get_node("anim").play("play")
			add_child(blood_effect)
			
			var data = get_node("/root/player")
			if collider.get_type()=="head":
				continue_head_shot_num+=1
				var cur_score = min( continue_head_shot_num+1, 5)
				get_node("ui/head_shot").set_text("HeadShot +"+String(cur_score))
				score += cur_score
				
				data.add_coin(cur_score)
			else:
				continue_head_shot_num = 0
				score +=1
				data.add_coin(1)
			
			get_node("ui/score").set_text(String(score))
			get_node("ui/coin").set_text(String(data.get_coin_num()))
			game_state = GameState.GS_CREATE_NEXT_BATTLE_MAP
		else:
			# 箭摇尾
			weapon.get_node("anim").play("attacked")
			
			game_state = GameState.GS_Failing
	else:
		game_state = GameState.GS_Failing
		
func create_next_battle_map():
	var character = get_node("archer")
	
	var next_battle_id = battle_id + 1
	next_battle_pos = Vector2(next_battle_id * 1024 + 50, 480)
		
	# gen column enemy
	var column = preload("res://actor/column/column_0.tscn").instance()
	column.set_battle_id(next_battle_id)
	var pos_y = 360 + randi() % 5 * 60
	column_pos = Vector2( next_battle_id * 1024 + 300 + randi() % 7 * 80, pos_y)
	column.set_pos(column_pos)
	get_node("column_enemy").add_child(column)
	game_state = GameState.GS_MOVETO_NEXT_BATTLE_MAP
		
func moveto_next_battle_map(delta):
	var character = get_node("archer")
	var cur_pos = character.get_pos()
	if cur_pos.x != next_battle_pos.x:
		var len = next_battle_pos.x - cur_pos.x
		var move_len = min(len, character_move_speed*delta)
		var next_pos = cur_pos + Vector2(move_len, 0.0)
		character.set_pos( next_pos)
		character.play_anim("run")
			
		var camera = get_node("camera")
		var cam_cur_pos = camera.get_pos()
		var cam_target_pos = character.get_pos() + cam_archer_offset
			
		# tween
		var next_target_pos = (cam_target_pos - cam_cur_pos) * 0.1 + cam_cur_pos
		var next_zoom = camera.get_zoom() + (Vector2(1.0, 1.0) - camera.get_zoom()) * 0.1
		camera.set_follow_smoothing(5.5)
		next_target_pos.y = max(next_target_pos.y, 128.0)
		camera.set_pos( next_target_pos)
		camera.set_zoom(next_zoom)
			
	else:
		character.play_anim("idle")
		
		# 到达目的地，生成箭支
		var camera = get_node("camera")
		camera.set_follow_smoothing(1.5)
		
		var character = get_node("archer")
		if has_node("weapon/arrow"):
			get_node("weapon/arrow").free()
			
		var arrow = load(character.get_weapon()).instance()
		get_node("weapon").add_child(arrow)
		
		get_node("weapon/arrow").set_pos(character.get_weapon_pos())
		get_node("weapon/arrow").set_scale(Vector2(3.0, 2.9))
		get_node("weapon/arrow").set_rot(character.get_weapon_rot())
		shoot_time = 0.0
		aim_degree = 0.0
		game_state = GS_DELETE_LAST_BATTLE_MAP
		
func delete_last_battle_map():			
	var column_enemy = get_node("column_enemy")
	for i in range(column_enemy.get_child_count()):
		var child = column_enemy.get_child(i)
		if child.get_battle_id()==battle_id:
			child.queue_free()
		
	battle_id = battle_id+1
	game_state = GameState.GS_PREPARE
	
func failing():
	var character = get_node("archer")	
	var camera = get_node("camera")
	var cam_cur_pos = camera.get_pos()
	var cam_target_pos = character.get_pos() + cam_archer_offset
	if (cam_cur_pos - cam_target_pos).length_squared() > 100.0:
		var next_target_pos = (cam_target_pos - cam_cur_pos) * 0.1 + cam_cur_pos
		var next_zoom = camera.get_zoom() + (Vector2(1.0, 1.0) - camera.get_zoom()) * 0.1
		next_target_pos.y = max(next_target_pos.y, 128.0)
		camera.set_pos( next_target_pos)
		camera.set_zoom(next_zoom)
	else:
		game_state = GameState.GS_Failed
	
func failed():
	get_node("ui/game_over").set_hidden(false)
	get_node("/root/player").on_get_new_cgmode_max_score(score)
