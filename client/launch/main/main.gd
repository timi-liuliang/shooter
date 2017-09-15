extends Control

func _ready():
	pass

func _on_play_pressed():
	get_node("/root/global").set_scene("res://game_single/game_single.tscn")

func _on_vs_pressed():
	get_node("/root/global").set_scene("res://game_single_vs/game_single_vs.tscn")

# 快速匹配
func _on_vs_online_pressed():
	# 当前是否有ID
	get_node("/root/network").set_target_net_state(3)

func _on_paihangpang_pressed():
	get_node("/root/network").send_ranking_request()
	
func _on_wechat_pressed():
	get_node("/root/wechat").send_msg()