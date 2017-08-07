extends Node

var wechat = null

func _ready():
	if(Globals.has_singleton("WeChat")):
		wechat = Globals.get_singleton("WeChat")
		wechat.init("wx0123213")
		wechat.connect("on_resp", self, "on_resp", [])
		
func send_msg():
	if wechat!=null:
		wechat.send_msg()
		print("share msg")
		
func on_resp(type, errCode, errStr):
	print(type)
	print(errCode)
	print(errStr)
