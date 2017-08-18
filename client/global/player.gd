extends Node

var is_logined = false

var file_name = "user://data.in"
var config_file = null
var total_kill_enemy_num = 0
var gold_coin_num		 = 0

func _ready():
	config_file = ConfigFile.new()
	if config_file.load(file_name) == OK:
		gold_coin_num = config_file.get_value("data", "coin", 0)

func get_coin_num():
	return gold_coin_num

func add_coin(num):
	gold_coin_num += num
	config_file.set_value("data", "coin", gold_coin_num)
	save()
	
func kill_enemy():
	pass
	
func save():
	config_file.save(file_name)
	