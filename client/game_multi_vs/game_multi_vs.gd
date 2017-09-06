extends Node2D

enum GameState{
	GS_PREPARE,
	GS_SHOW_ENEMY,
	GS_FOCUS_PLAYER,
	GS_WAIT_FOR_AIM,
	GS_PLAYER_AIM,
	GS_PLAYER_SHOOT_EMIT,
	GS_PLAYER_SHOOT,
	GS_CHECK_SHOOT_RESULT,
	GS_WAIT_SHOOT_RESULT,
	GS_FAILING,
	GS_FAILED,
	GS_WINING,
	GS_WINED
}

var players = []
var parabola = null
var game_state =GameState.GS_PREPARE
var score = int(0)
var cam_archer_offset
var cam_arrow_offset
var aim_degree = 0.0
var aim_degree_sync = 0.0
var aim_adjust_dir = 1.0
var player_aim_sync_interval = 100
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
var main_player_idx = 0			# 主角索引
var active_player_idx = 0		# 当前活跃玩家
var robot_aim_degree = 0.0
var robot_target_aim_degree = -90.0
var robot_init_speed = 300
var net_heart_beat = 0.0

func _ready():
	var camera = get_node("camera")
	Globals.set("main_camera", camera)
	
	# 初始开启匹配界面
	get_node("ui/room_match").set_hidden(false)
	
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
	if game_state == GameState.GS_SHOW_ENEMY:
		show_enemy()
	elif game_state == GameState.GS_FOCUS_PLAYER:
		focus_player(active_player_idx)
	elif game_state == GameState.GS_WAIT_FOR_AIM:
		wait_for_aim(active_player_idx)
	elif game_state == GameState.GS_PLAYER_AIM:
		player_aim(delta, active_player_idx)
	elif game_state == GameState.GS_PLAYER_SHOOT:
		shoot(delta)
	elif game_state == GameState.GS_CHECK_SHOOT_RESULT:
		check_result()
	elif game_state == GameState.GS_FAILING:
		failing()
	elif game_state == GameState.GS_FAILED:
		failed()
	elif game_state == GameState.GS_WINING:
		wining()
	elif game_state == GameState.GS_WINED:
		wined()
		
	net_heart_beat += delta
	if net_heart_beat > 5.0:
		get_node("/root/network").send_heart_beat()
		net_heart_beat = 0.0
		
		var ping = get_node("/root/network").get_ping_value()
		get_node("ui/ping").set_text("Ping:"+String(ping))
		
func prepare():
	pass

func show_enemy():
	var enemy_pos = get_enemy(main_player_idx).get_pos() + Vector2(0, -150)
	var camera = get_node("camera")	
	if camera.get_pos()!= enemy_pos || (camera.get_zoom()-Vector2(1.0, 1.0)).length_squared() > 0.01:
		camera.set_enable_follow_smoothing( false)
		camera.set_pos( enemy_pos)
		camera.set_zoom( camera.get_zoom() + (Vector2(1.0, 1.0) - camera.get_zoom()) * 0.02)
	else:
		camera.set_enable_follow_smoothing( true)
		game_state = GameState.GS_FOCUS_PLAYER
		
func focus_player(idx):
	var player_pos = players[idx].get_pos() + Vector2(0, -150)
	if idx==0:
		player_pos.x += 256.0
	else:
		player_pos.x -= 256.0
	
	var camera = get_node("camera")
	if camera.get_pos()!= player_pos:
		var move_dir = player_pos - camera.get_pos()
		var length      = move_dir.length()
		move_dir = move_dir.normalized()
		if length<10:
			camera.set_pos(player_pos)
		else:
			var move_speed = 10
			var move_len = min(move_speed, length)
			camera.set_pos( camera.get_pos() + move_dir * move_len)
	else:
		add_weapon_to(idx)
		players[idx].set_weapon_hidden(false)
		get_node("weapon/arrow").set_hidden(true)
		if active_player_idx == main_player_idx:
			get_node("ui/your_turn").set_text("Your Turn")
		game_state = GameState.GS_WAIT_FOR_AIM

func wait_for_aim(idx):
	if idx == main_player_idx:
		if Input.is_action_pressed("touch"):
			game_state = GameState.GS_PLAYER_AIM
	else:
		game_state = GameState.GS_PLAYER_AIM
	
func player_aim(delta, idx):
	if idx == main_player_idx:
		main_player_aim(delta, idx)
	else:
		enemy_player_aim_sync(delta, idx)
	
func main_player_aim(delta, idx):
	if Input.is_action_pressed("touch"):	
		aim_degree += delta * 60.0 * aim_adjust_dir
		if aim_degree > 89.0:
			aim_adjust_dir = -1.0
		if aim_degree <0.0:
			aim_adjust_dir = 1.0
			
		var player = players[idx]
		player.set_hand_rot(deg2rad(aim_degree))
		
		var weapon = get_node("weapon/arrow")
		weapon.set_pos(player.get_weapon_pos())
		weapon.set_rot(player.get_weapon_rot())
		var weapon_head_pos = weapon.get_node("display/head").get_global_pos()
		
		# show aiming
		get_node("aiming_sight").set_hidden(false)
		get_node("aiming_sight").set_param(weapon_head_pos, init_speed, get_player_aim_degree(idx, aim_degree), wind_slow_down, gravity)
		
		# send msg
		player_aim_sync_interval += delta
		if(player_aim_sync_interval > 0.1):
			get_node("/root/network").send_battle_player_aim(aim_degree)
			player_aim_sync_interval = 0.0
		
	if !Input.is_action_pressed("touch"):
		# 向服务器发送"shooter"消息
		var weapon = get_node("weapon/arrow")
		get_node("/root/network").battle_player_shoot(weapon.get_pos(), get_player_aim_degree(idx, aim_degree))
		game_state = GameState.GS_PLAYER_SHOOT_EMIT
		
func enemy_player_aim_sync(delta, idx):
	if aim_degree_sync > aim_degree:
		aim_degree = min(aim_degree + delta * 60.0, aim_degree_sync)
	if aim_degree_sync <aim_degree:
		aim_degree = max(aim_degree - delta * 60.0, aim_degree_sync)
	
	var player = players[idx]
	player.set_hand_rot(deg2rad(aim_degree))
		
	var weapon = get_node("weapon/arrow")
	weapon.set_pos(player.get_weapon_pos())
	weapon.set_rot(player.get_weapon_rot())
	var weapon_head_pos = weapon.get_node("display/head").get_global_pos()
		
func on_player_shoot(idx, weapon_pos, degree):
	var player = players[idx]
	player.set_weapon_hidden(true)
	get_node("weapon/arrow").set_hidden(false)
	get_node("aiming_sight").set_hidden(true)
		
	# 抛物线
	parabola.set(weapon_pos, degree, init_speed, Vector2(-wind_slow_down, gravity))
	aim_degree = 0.0
	game_state = GameState.GS_PLAYER_SHOOT
		
		
func get_player_aim_degree(idx, origin_degree):
	if players[idx].is_mirror():
		return 180.0 - origin_degree
	else:
		return origin_degree
		
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
		if true : # weapon.get_pos().x < cha_pos.x + 924:
			var camera = get_node("camera")
			var cam_cur_pos = camera.get_pos()
			var cam_target_pos = weapon.get_pos()# + cam_arrow_offset * 0.2
			var next_target_pos = (cam_target_pos - cam_cur_pos) * 0.1 + cam_cur_pos
			var cam_target_zoom = Vector2(max(1.0-shoot_time*0.2, 0.5), max(1.0-shoot_time*0.2, 0.5))
			#var next_zoom = camera.get_zoom() + (cam_target_zoom - camera.get_zoom()) * 0.05
			next_target_pos.y = max(next_target_pos.y, 128.0)
			camera.set_pos( next_target_pos)
			#camera.set_zoom(next_zoom)
			
		# 回复射击初始姿势
		var character = get_self()
		var cha_hand_rot = character.get_hand_rot()
		cha_hand_rot = max( 0.0, cha_hand_rot - delta* 10)
		character.set_hand_rot( cha_hand_rot)
		
	var arrow_pos_x = weapon.get_pos().x	
	if weapon.is_colliding():
		shoot_time = 0.0
		game_state = GameState.GS_CHECK_SHOOT_RESULT	
		
func check_result():
	var weapon = get_node("weapon/arrow")
	if weapon.is_colliding():
		var collider = weapon.get_collider()
		if collider.is_type("KinematicBody2D"):	
			# 箭摇尾
			collider.on_attack()
			weapon.get_node("anim").play("attacked")
			
	if active_player_idx == main_player_idx:				
		get_node("/root/network").send_battle_player_blood(get_self().cur_blood, get_enemy(main_player_idx).cur_blood)		
		
	game_state = GameState.GS_WAIT_SHOOT_RESULT
	
func failing():
	var character = get_self()	
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
		game_state = GameState.GS_FAILED
	
func failed():
	get_node("ui/game_over").set_hidden(false)
	
func wining():
	game_state = GameState.GS_WINED
	
func wined():
	get_node("ui/vs_win").set_hidden(false)
	
func get_enemy(self_idx):
	if self_idx == 0:
		return players[1]
	else:
		return players[0]
		
func get_self():
	return players[main_player_idx]
		
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
	weapon.set_player_idx(i)

func update_blood_display():
	get_node("ui/blood/player_0").set_value(players[0].cur_blood)
	get_node("ui/blood/player_1").set_value(players[1].cur_blood)
	
func get_type():
	return 1
	
#########################net message#########################
func on_msg_battle_player_enter(msg):
	if msg.player==get_node("/root/account_mgr").get_player_id():
		main_player_idx = msg.pos;
		print("main player idx:", main_player_idx)
		
func on_msg_battle_begin(msg):
	print("on_msg_battle_begin")
	get_node("ui/room_match").set_hidden(true)
	game_state = GameState.GS_SHOW_ENEMY
	
func on_msg_battle_time(msg):
	var minute = msg.battle_time / 60
	var second = msg.battle_time % 60
	var str_time = "%02d:%02d" % [minute,second]
	get_node("ui/battle_time").set_text(str_time)
	
	var turn_second = msg.turn_time;
	get_node("ui/turn_time").set_text(String(turn_second))
	
func on_msg_battle_turn_begin(msg):
	if msg.player==get_node("/root/account_mgr").get_player_id():
		active_player_idx = main_player_idx
	else:
		active_player_idx = (main_player_idx + 1) % players.size()
		
	game_state = GameState.GS_FOCUS_PLAYER
	
func on_msg_battle_player_shoot(msg):
	on_player_shoot(active_player_idx, Vector2(msg.weapon_pos_x, msg.weapon_pos_y), msg.degree)
	
func on_msg_battle_player_shoot_result(msg):
	# set blood
	players[0].cur_blood = msg.player0_blood
	players[1].cur_blood = msg.player1_blood
	update_blood_display()
	
	if get_self().cur_blood <= 0:
		game_state = GameState.GS_FAILING	
	elif get_enemy(main_player_idx).cur_blood <=0:
		game_state = GameState.GS_WINING
	else:
		if active_player_idx==main_player_idx:
			get_node("/root/network").send_battle_switch_turn()
	
func on_msg_battle_player_relogin(msg):
	# confirm position
	if msg.player0==get_node("/root/account_mgr").get_player_id():
		main_player_idx = msg.pos0;
		
	if msg.player1==get_node("/root/account_mgr").get_player_id():
		main_player_idx = msg.pos1;
	
	# set blood
	players[0].cur_blood = msg.player0_blood
	players[1].cur_blood = msg.player1_blood
	update_blood_display()
	
	# hide searching ui
	get_node("ui/room_match").set_hidden(true)
	
	# turn
	if msg.turn_player==get_node("/root/account_mgr").get_player_id():
		active_player_idx = main_player_idx
	else:
		active_player_idx = (main_player_idx + 1) % players.size()
		
	game_state = GameState.GS_FOCUS_PLAYER
	
func on_msg_battle_sync_aim_degree(msg):
	aim_degree_sync = msg.aim_degree
	