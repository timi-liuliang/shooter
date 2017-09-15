extends Node2D

func _ready():
	set_process(true)
	
func _process(delta):
	if !has_node("/root/global"):
		var global = load("res://global/global.gd").new()
		global.set_name("global")
		get_tree().get_root().add_child(global)
		
		update_coin_num_display()

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
	
func update_coin_num_display():
	var data = get_node("/root/player")
	get_node("ui/jinbi/Label").set_text(String(data.get_coin_num()))


func _on_paihangpang_pressed():
	get_node("/root/network").send_ranking_request()
	
func on_loaded_rakinglist(msg):
	var dict = {}
	if(dict.parse_json(msg.ranking)==OK):
		print(msg.ranking)
	else:
		print("Dictionary parse failed")

