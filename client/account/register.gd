extends Control

func _ready():
	pass

func _on_register_pressed():
	var account = get_node("account").get_text()
	var password= get_node("password").get_text()
	if get_node("password").get_text().length()<6:
		print('Password length is too short')
		return
		
	if get_node("password").get_text() != get_node("password_confirm").get_text():
		print('两次密码输入不一致')
		return
	
	if is_email(account):
		get_node("/root/network").register_by_email(account, password)
	else:
		print("The account type is not support, you can only use email or phone number")
	
func is_email( email):
	return email.ends_with('.com') and (email.find('@')!=-1)
