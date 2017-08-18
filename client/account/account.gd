extends Node

var file_name = "user://apps/shooter/pw.bin"
var config_file = null
var account = ""
var password = ""

func _ready():
	config_file = ConfigFile.new()
	if config_file.load(file_name) == OK:
		account = config_file.get_value("data", "account", "")
		password = config_file.get_value("data", "password", "")
	
func get_account():
	return account
	
func register_account():
	var unique_id = OS.get_unique_ID()
	if unique_id == "":
		pass
	else:
		pass
		
func login():
	var unique_id = OS.get_unique_ID()
	if unique_id == "":
		if account=="":
			# 弹出登录界面
			get_node("login").set_hidden(false)
		else:
			get_node("/root/network").login_by_email(account, password)		
	else:
		# 根据 OS unique_id 生成账号
		get_node("/root/network").login_by_osid(unique_id)
			
func game_room_match():
	print("search enemy")

# 快速匹配
func _on_vs_online_pressed():
		# 当前是否有ID
	var account = get_account()
	if account=="":
		login()
	else:
		game_room_match()

func _on_register_pressed():
	get_node("login").set_hidden(true)
	get_node("register").set_hidden(false)
	
func on_receive_register_result(msg):
	if msg.result==0:
		get_node("register/info").set_text("register succeed")
		get_node("register").set_hidden(true)
		account = get_node("register/account").get_text()
		password = get_node("register/password").get_text()
		save_account()
		
		get_node("/root/network").login_by_email(account, password)
		
	elif msg.result==1:
		get_node("register/info").set_text("This email has been used, You can login with it")
		
func on_receive_login_result(msg):
	if msg.result==0:
		get_node("login").set_hidden(true)
		get_node("register").set_hidden(true)
		save_account()
	elif msg.result==1:
		get_node("login/info").set_text("login failed, the account isn't exist or the password is wrong.")
		
func save_account():
	config_file.set_value("data", "account", account)
	config_file.set_value("data", "password", password)
	config_file.save(file_name)

func _on_login_pressed():
	account = get_node("login/account").get_text()
	password = get_node("login/password").get_text()
	if is_email(account):
		get_node("/root/network").login_by_email(account, password)
	else:
		get_node("login/info").set_text("the account isn't a email address")
	
func is_email( email):
	var is_end_with_com = email.ends_with('.com')
	var is_have_at = email.find('@')!=-1	
	return  is_end_with_com and is_have_at
