extends Node

func _ready():
	pass

func _on_register_pressed():
	get_node("login").set_hidden(true)
	get_node("register").set_hidden(false)
	
func on_receive_register_result(msg):
	if msg.result==0:
		get_node("register/info").set_text("register succeed")
		get_node("register").set_hidden(true)
		var account = get_node("register/account").get_text()
		var password = get_node("register/password").get_text()
		save_account( account, password)
		
		get_node("/root/network").login_by_email(account, password)
		
	elif msg.result==1:
		get_node("register/info").set_text("This email has been used, You can login with it")
		
func on_receive_login_result(msg):
	if msg.result==0:
		get_node("login").set_hidden(true)
		get_node("register").set_hidden(true)
		var account = get_node("login/account").get_text()
		var password = get_node("login/password").get_text()
		get_node("/root/account_mgr").save_account( account, password)
		
		get_node("/root/global").set_scene("res://launch/launch.tscn")
		
	elif msg.result==1:
		print("hahahahha")
		get_node("login/info").set_text("login failed, the account isn't exist or the password is wrong.")

func _on_login_pressed():
	var account = get_node("login/account").get_text()
	var password = get_node("login/password").get_text()
	if is_email(account):
		get_node("/root/network").login_by_email(account, password)
	else:
		get_node("login/info").set_text("the account isn't a email address")
	
func is_email( email):
	var is_end_with_com = email.ends_with('.com')
	var is_have_at = email.find('@')!=-1	
	return  is_end_with_com and is_have_at


func _on_return_login_pressed():
	get_node("login").set_hidden(false)
	get_node("register").set_hidden(true)


func _on_close_pressed():
	get_node("/root/global").set_scene("res://launch/launch.tscn")
