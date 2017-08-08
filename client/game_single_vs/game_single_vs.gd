extends Node2D

enum GameState{
	GS_PREPARE,
	GS_FOCUS_ENEMY,
	GS_FOCUS_SELF,
	GS_WAIT_FOR_AIM,
	GS_SELF_AIM,
	GS_SELF_SHOOT,
	GS_CHECK_SHOOT_RESULT,
	GS_Failing,
	GS_Failed
	GS_WINING,
}

var players = []
var parabola = null
var game_state =GameState.GS_PREPARE
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
var is_player_0 = true

func _ready():
	players.append(get_node("player_0"))
	players.append(get_node("player_1"))
	for i in range(players.size()):
		players[i].set_layer_mask(0)
		players[i].set_layer_mask_bit(i, true)
	
	# 抛物线
	parabola = preload("res://global/parabola.gd").new()
	
	cam_archer_offset = get_node("camera").get_pos() - get_node("player_0").get_pos()
	cam_arrow_offset  = get_node("camera").get_pos() - get_node("player_0").get_pos()
	
	# request ad
	if(Globals.has_singleton("Gomob")):
		var gomob = Globals.get_singleton("Gomob")
		gomob.request_videoad()
	
	set_process(true)
	
func _process(delta):
	if game_state == GameState.GS_PREPARE:
		prepare()
	if game_state == GameState.GS_FOCUS_ENEMY:
		focus_enemy()
	elif game_state == GameState.GS_FOCUS_SELF:
		focus_self()
	elif game_state == GameState.GS_WAIT_FOR_AIM:
		wait_for_aim()
	elif game_state == GameState.GS_SELF_AIM:
		self_aim(delta)
	elif game_state == GameState.GS_SELF_SHOOT:
		shoot(delta)
	elif game_state == GameState.GS_CHECK_SHOOT_RESULT:
		check_result()
	elif game_state == GameState.GS_Failing:
		failing()
	elif game_state == GameState.GS_Failed:
		failed()
		
func prepare():
	game_state = GameState.GS_FOCUS_ENEMY

func focus_enemy():
	var enemy_pos = get_enemy().get_pos() + Vector2(0, -150)
	var camera = get_node("camera")	
	if camera.get_pos()!= enemy_pos || (camera.get_zoom()-Vector2(1.0, 1.0)).length_squared() > 0.01:
		camera.set_enable_follow_smoothing( false)
		camera.set_pos( enemy_pos)
		camera.set_zoom( camera.get_zoom() + (Vector2(1.0, 1.0) - camera.get_zoom()) * 0.02)
	else:
		camera.set_enable_follow_smoothing( true)
		game_state = GameState.GS_FOCUS_SELF
		
func focus_self():
	var self_pos = get_self().get_pos() + Vector2(0, -150)
	var camera = get_node("camera")
	if camera.get_pos()!= self_pos || (camera.get_zoom()-Vector2(1.0, 1.0)).length_squared() > 0.01:
		if (camera.get_pos()-self_pos).length_squared()<0.1:
			camera.set_pos(self_pos)
		else:
			camera.set_pos( camera.get_pos() +(self_pos - camera.get_pos())*0.02)
		camera.set_zoom( camera.get_zoom() + (Vector2(1.0, 1.0) - camera.get_zoom()) * 0.02)
	else:
		add_weapon_to(0)
		get_self().set_weapon_hidden(false)
		get_node("weapon/arrow").set_hidden(true)
		game_state = GameState.GS_WAIT_FOR_AIM

func wait_for_aim():
	if Input.is_action_pressed("touch"):
		game_state = GameState.GS_SELF_AIM
	
func self_aim(delta):
	if Input.is_action_pressed("touch"):	
		aim_degree += delta * 60.0 * aim_adjust_dir
		if aim_degree > 89.0:
			aim_adjust_dir = -1.0
		if aim_degree <0.0:
			aim_adjust_dir = 1.0
			
		var character = get_self()
		character.set_hand_rot(deg2rad(aim_degree))
		
		var weapon = get_node("weapon/arrow")
		weapon.set_pos(character.get_weapon_pos())
		weapon.set_rot(character.get_weapon_rot())
		var weapon_head_pos = weapon.get_node("display/head").get_global_pos()
		
		# show aiming
		get_node("aiming_sight").set_hidden(false)
		get_node("aiming_sight").set_param(weapon_head_pos, init_speed, aim_degree, wind_slow_down, gravity)
		
	if !Input.is_action_pressed("touch"):
		var character = get_self()
		character.set_weapon_hidden(true)
		get_node("weapon/arrow").set_hidden(false)
		get_node("aiming_sight").set_hidden(true)
		
		# 抛物线
		var weapon = get_node("weapon/arrow")
		parabola.set(weapon.get_pos(), aim_degree, init_speed, Vector2(-wind_slow_down, gravity))
		
		game_state = GameState.GS_SELF_SHOOT
		
func shoot(delta):
	var weapon = get_node("weapon/arrow")
	var cha_pos = get_self().get_pos()
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
			camera.set_pos( next_target_pos)
			camera.set_zoom(next_zoom)
			
		# 回复射击初始姿势
		var character = get_self()
		var cha_hand_rot = character.get_hand_rot()
		cha_hand_rot = max( 0.0, cha_hand_rot - delta* 10)
		character.set_hand_rot( cha_hand_rot)
		
	var arrow_pos_x = weapon.get_pos().x	
	if weapon.is_colliding() || arrow_pos_x > (cha_pos.x + 1124):
		shoot_time = 0.0
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
			
			if collider.get_type()=="head":
				continue_head_shot_num+=1
				var cur_score = min( continue_head_shot_num+1, 5)
				get_node("ui/head_shot").set_text("HeadShot +"+String(cur_score))
				score += cur_score
			else:
				continue_head_shot_num = 0
				score +=1
			
			get_node("ui/score").set_text(String(score))
			game_state = GameState.GS_CREATE_NEXT_BATTLE_MAP
		else:
			# 箭摇尾
			weapon.get_node("anim").play("attacked")
			
			game_state = GameState.GS_Failing

	if get_self().cur_blood <= 0:
		game_state = GameState.GS_Failing	
	elif get_enemy().cur_blood <=0:
		game_state = GameState.GS_WINING
	else:
		game_state = GameState.GS_FOCUS_SELF
	
func failing():
	var character = get_self()	
	var camera = get_node("camera")
	var cam_cur_pos = camera.get_pos()
	var cam_target_pos = character.get_pos() + cam_archer_offset
	if (cam_cur_pos - cam_target_pos).length_squared() > 100.0:
		var next_target_pos = (cam_target_pos - cam_cur_pos) * 0.1 + cam_cur_pos
		var next_zoom = camera.get_zoom() + (Vector2(1.0, 1.0) - camera.get_zoom()) * 0.1
		camera.set_pos( next_target_pos)
		camera.set_zoom(next_zoom)
	else:
		game_state = GameState.GS_Failed
	
func failed():
	get_node("ui/game_over").set_hidden(false)
	
func get_enemy():
	if is_player_0:
		return get_node("player_1")
	else:
		return get_node("player_0")
		
func get_self():
	if is_player_0:
		return get_node("player_0")
	else:
		return get_node("player_1")
		
func add_weapon_to( i):
	var character = players[i]
	if has_node("weapon/arrow"):
		get_node("weapon/arrow").free()
			
	var arrow = preload("res://actor/weapon/stick.tscn").instance()
	get_node("weapon").add_child(arrow)
	
	var weapon = get_node("weapon/arrow")
	weapon.set_hidden(true)
	weapon.set_pos(character.get_weapon_pos())
	weapon.set_scale(Vector2(3.0, 2.9))
	weapon.set_rot(character.get_weapon_rot())
	weapon.set_collision_mask(0xFFFFFFFF)
	weapon.set_collision_mask_bit(i, false)
		
