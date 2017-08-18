extends Node2D

func _ready():
	set_process(true)
	
func _process(delta):
	if !has_node("/root/global"):
		var global = load("res://global/global.gd").new()
		global.set_name("global")
		get_tree().get_root().add_child(global)

func _on_play_pressed():
	get_node("/root/global").set_scene("res://game_single/game_single.tscn")

func _on_wechat_pressed():
	get_node("/root/wechat").send_msg()

func _on_vs_pressed():
	get_node("/root/global").set_scene("res://game_single_vs/game_single_vs.tscn")

# 快速匹配
func _on_vs_online_pressed():
	# 当前是否有ID
	get_node("/root/network").set_target_net_state(3)
