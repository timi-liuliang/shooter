extends Node

# 网络状态
enum NetState{
	DISCONNECTED = 0,
	CONNECTED,
	LOGINED,
	SEARCHING,
	IN_BATTLE_ROOM
}

var streamPeerTCP = null
var msg_bind = []
var end_flag = 64
var last_byte = 0
var cur_package = ByteBuf.new()
var time_out = -1
var cur_net_state = NetState.DISCONNECTED
var target_net_state = NetState.LOGINED
var nonHeartBeatTime = 0.0

func _ready():
	bind_msgs()
	set_process(true)
	
func _process(delta):		
	# parse msg	
	if streamPeerTCP and streamPeerTCP.is_connected():
		# 验证心跳
		nonHeartBeatTime += delta;
		if nonHeartBeatTime > 30.0:
			set_target_net_state(NetState.DISCONNECTED)
		
		var availableBytes = streamPeerTCP.get_available_bytes()
		while availableBytes > 0:
			process_net_byte(streamPeerTCP.get_u8())
			availableBytes = streamPeerTCP.get_available_bytes()
	else:
		cur_net_state = NetState.DISCONNECTED
		
	update_net_state(delta)
		
func update_net_state(delta):
	if cur_net_state < target_net_state:
		time_out -= delta
		if cur_net_state==NetState.DISCONNECTED and time_out<=0:
			print("update net state A")
			connect_server()
			time_out = 30
			
		if cur_net_state==NetState.DISCONNECTED and streamPeerTCP.is_connected():
			set_cur_net_state( NetState.CONNECTED)
			print("update net state B")
			
		if cur_net_state==NetState.CONNECTED and time_out<=0:
			get_node("/root/account_mgr").login()
			print("update net state C")
			time_out=10
		
		if cur_net_state==NetState.LOGINED and time_out < 0:
			search_room_begin()
			time_out = 10
			
		#print("update net state E")

func set_cur_net_state(state):
	cur_net_state = state
	time_out = 0.0
			
func set_target_net_state(state):
	if state == NetState.DISCONNECTED:
		streamPeerTCP.disconnect()
	
	time_out = 0.0
	target_net_state = state
	
	print("set_target_net_state")
	
func connect_server():
	if streamPeerTCP!=null and streamPeerTCP.is_connected():
		streamPeerTCP.disconnect()
	
	streamPeerTCP = StreamPeerTCP.new()
	if OK!=streamPeerTCP.connect('localhost', 8800):
		print("connect server failed")
		set_cur_net_state(NetState.DISCONNECTED)
		set_target_net_state(NetState.DISCONNECTED)
			
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		if streamPeerTCP!=null and streamPeerTCP.is_connected():
			streamPeerTCP.disconnect()
			target_net_state = NetState.DISCONNECTED
	
func bind( msg):
	var msgInst = msg.new()
	var id  = msgInst.id()
	var fun_cb = funcref(self, "on_msg_%s" % msgInst.name())
	if id+1 > msg_bind.size():
		msg_bind.resize(id+1)
		 
	msg_bind[id] = [msgInst, fun_cb]
		
func process_net_byte(byte):
	if last_byte!=end_flag and byte!=end_flag:
		cur_package.write_byte(byte)
		last_byte = byte
	elif last_byte==end_flag and byte==end_flag:
		process_net_package(cur_package)
		cur_package = ByteBuf.new()
		last_byte = 0
	elif last_byte==end_flag and byte!=end_flag:
		cur_package.write_byte(last_byte)
		cur_package.write_byte(byte)
		last_byte = byte
	else:	
		last_byte = byte
	
func process_net_package(buf):
	var msg_id = buf.read_i32()
	var msg_length = buf.read_i32()
	if msg_id < msg_bind.size():
		var msg = msg_bind[msg_id][0]
		var msg_cb = msg_bind[msg_id][1]	
		msg.parse_data(buf)
		msg_cb.call_func(msg)
	else:
		print("process_net_package failed")
	
func register_by_email(email, password):
	if streamPeerTCP.is_connected():
		var msg = preload("res://global/protocol/register_by_email.pb.gd").new()
		msg.email = email
		msg.password = password
		msg.send(streamPeerTCP)
		
func login_by_email( email, password):
	if streamPeerTCP.is_connected():	
		var login_msg = preload("res://global/protocol/login_by_email.pb.gd").new()
		login_msg.email = email
		login_msg.password = password
		login_msg.send(streamPeerTCP)
	
func login_by_osid():
	if streamPeerTCP.is_connected():	
		var login_msg = preload("res://global/protocol/login_by_osid.pb.gd").new()
		login_msg.account = 1
		login_msg.password = 9
		login_msg.send(streamPeerTCP)
		
func send_heart_beat():
	if streamPeerTCP.is_connected():
		var msg = preload("res://global/protocol/heart_beat.pb.gd").new()
		msg.send(streamPeerTCP)
		
# 搜寻房间
func search_room_begin():
	print("search room begin")
	if streamPeerTCP.is_connected():
		var search_room_msg = preload("res://global/protocol/search_room_begin.pb.gd").new()
		search_room_msg.send(streamPeerTCP)
		
func search_room_end():
	if streamPeerTCP.is_connected():
		var search_room_msg = preload("res://global/protocol/search_room_end.pb.gd").new()
		search_room_msg.send(streamPeerTCP)
		
func battle_player_shoot(weapon_pos, degree):
	if streamPeerTCP.is_connected():
		var msg = preload("res://global/protocol/battle_player_shoot.pb.gd").new()
		msg.weapon_pos_x = weapon_pos.x
		msg.weapon_pos_y = weapon_pos.y
		msg.degree = degree
		msg.send(streamPeerTCP)
		
func send_battle_switch_turn():
	if streamPeerTCP.is_connected():
		var msg = preload("res://global/protocol/battle_switch_turn.pb.gd").new()
		msg.send(streamPeerTCP)	
		
func send_battle_player_blood(cur_blood):
	if streamPeerTCP.is_connected():
		var msg = preload("res://global/protocol/battle_player_blood.pb.gd").new()
		msg.blood = cur_blood
		msg.send(streamPeerTCP)	

func collect_item(id):
	if streamPeerTCP.is_connected():	
		var collect_item_msg = preload("res://global/protocol/collect_item.pb.gd").new()
		collect_item_msg.id = id
		collect_item_msg.count = 1
		collect_item_msg.type = 1
		collect_item_msg.send(streamPeerTCP)
		
func eat_item(slot_idx):
	print("eat", slot_idx)
	if streamPeerTCP.is_connected():	
		var msg = preload("res://global/protocol/eat_item.pb.gd").new()
		msg.slot_idx = slot_idx
		msg.send(streamPeerTCP)
		
func on_attacked(damage):
	if streamPeerTCP.is_connected():
		var on_attacked_msg = preload("res://global/protocol/on_attacked.pb.gd").new()
		on_attacked_msg.damage = damage
		on_attacked_msg.send(streamPeerTCP)

func bind_msgs():
	bind(preload("res://global/protocol/register_result.pb.gd"))
	bind(preload("res://global/protocol/login_result.pb.gd"))
	bind(preload("res://global/protocol/heart_beat.pb.gd"))
	bind(preload("res://global/protocol/player_info.pb.gd"))
	bind(preload("res://global/protocol/search_room_result.pb.gd"))
	bind(preload("res://global/protocol/battle_player_enter.pb.gd"))
	bind(preload("res://global/protocol/battle_begin.pb.gd"))
	bind(preload("res://global/protocol/battle_time.pb.gd"))
	bind(preload("res://global/protocol/battle_turn_begin.pb.gd"))
	bind(preload("res://global/protocol/battle_player_shoot.pb.gd"))
	
	bind(preload("res://global/protocol/backpack_num.pb.gd"))
	bind(preload("res://global/protocol/backpack_cell.pb.gd"))
	bind(preload("res://global/protocol/blood_info.pb.gd"))
	bind(preload("res://global/protocol/game_time.pb.gd"))
	
func on_msg_register_result( msg):
	if has_node("/root/account"):
		get_node("/root/account").on_receive_register_result(msg)
		
func on_msg_login_result( msg):
	if msg.result==0:
		set_cur_net_state(NetState.LOGINED)
	
	if has_node("/root/account"):		
		get_node("/root/account").on_receive_login_result(msg)
		
func on_msg_heart_beat(msg):
	nonHeartBeatTime = 0.0
		
func on_msg_player_info(msg):
	get_node("/root/account_mgr").on_receive_player_info(msg)
		
func on_msg_search_room_result(msg):
	if msg.result==1:
		get_node("/root/global").set_scene("res://game_multi_vs/game_multi_vs.tscn")
		set_cur_net_state(NetState.LOGINED)
		set_target_net_state(NetState.LOGINED)
		print("battle searching")
	elif msg.result==0:
		get_node("/root/global").set_scene("res://launch/launch.tscn")
		set_cur_net_state(NetState.LOGINED)
		set_target_net_state(NetState.LOGINED)
		print("quite battle")
		
func on_msg_battle_player_enter(msg):
	if has_node("/root/game"):
		if get_node("/root/game").get_type()==1:
			get_node("/root/game").on_msg_battle_player_enter(msg)
		else:
			print("stange message from server")
		
func on_msg_battle_begin(msg):
	if has_node("/root/game"):
		if get_node("/root/game").get_type()==1:
			get_node("/root/game").on_msg_battle_begin(msg)
		else:
			print("stange message from server")	
			
func on_msg_battle_time(msg):
	if has_node("/root/game"):
		if get_node("/root/game").get_type()==1:
			get_node("/root/game").on_msg_battle_time(msg)
		else:
			print("stange message from server")		
			
func on_msg_battle_turn_begin(msg):
	if has_node("/root/game"):
		if get_node("/root/game").get_type()==1:
			get_node("/root/game").on_msg_battle_turn_begin(msg)
		else:
			print("stange message from server")
					
func on_msg_battle_player_shoot(msg):
	if has_node("/root/game"):
		if get_node("/root/game").get_type()==1:
			get_node("/root/game").on_msg_battle_player_shoot(msg)
		else:
			print("stange message from server")
			
			
func on_msg_backpack_num( msg):
	get_tree().get_root().get_node("level/ui/little bag").set_slot_size(msg.num)
	
func on_msg_backpack_cell( msg):
	get_tree().get_root().get_node("level/ui/little bag").set_slot_info( msg.index, msg.item_id, msg.item_num)
	
func on_msg_blood_info( msg):
	Globals.get("main_character").set_blood_info( msg.cur_blood, msg.max_blood)

func on_msg_game_time( msg):
	get_node("/root/global").setGameTime(msg.time)
