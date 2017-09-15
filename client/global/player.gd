extends Node

var is_logined = false

var file_name = "user://data.in"
var config_file = null
var total_kill_enemy_num = 0
var gold_coin_num		 = 0
var chuangguan_mode_max_score = 0

func _ready():
	config_file = ConfigFile.new()
	if config_file.load(file_name) == OK:
		gold_coin_num = config_file.get_value("data", "coin", 0)
		chuangguan_mode_max_score = config_file.get_value("data", "max_score", 0)

func get_coin_num():
	return gold_coin_num

func add_coin(num):
	gold_coin_num += num
	config_file.set_value("data", "coin", gold_coin_num)
	save()
	
func get_cgmode_max_score():
	return chuangguan_mode_max_score
	
func on_get_new_cgmode_max_score(score):
	if score>chuangguan_mode_max_score:
		chuangguan_mode_max_score = score
		
		config_file.set_value("data", "max_score", chuangguan_mode_max_score)
		save()
		
	get_node("/root/network").send_max_score(score)
	
func kill_enemy():
	pass
	
func save():
	config_file.save(file_name)
	