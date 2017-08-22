extends Node

var file_name = "user://shooter_pw.bin"
var config_file = null
var account = ""
var password = ""

var is_have_player = false
var player_id = -1
var player_name = ""

func _ready():
	config_file = ConfigFile.new()
	if config_file.load(file_name) == OK:
		account = config_file.get_value("data", "account", "")
		password = config_file.get_value("data", "password", "")

func login():
	var unique_id = ""
	if OS.get_name()=="Android" || OS.get_name()=="iOS": 
		unique_id = OS.get_unique_ID()
		
	if unique_id == "":
		if account=="":
			# 弹出登录界面
			if !has_node("/root/account"):
				get_node("/root/global").set_scene("res://account/account.tscn")
		else:
			get_node("/root/network").login_by_email(account, password)		
	else:
		# 根据 OS unique_id 生成账号
		get_node("/root/network").login_by_osid(unique_id)
		
func save_account(acc, pas):
	account = acc
	password = pas
	config_file.set_value("data", "account", account)
	config_file.set_value("data", "password", password)
	config_file.save(file_name)
		
func on_receive_player_info(msg):
	is_have_player = true;
	player_id = msg.player
	player_name = msg.name
	print("-----------------", msg.player)
	
func get_player_id():
	return player_id
