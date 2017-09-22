extends RigidBody2D

var battle_id = 0
export(String, "ground", "column", "body", "head") var type = String("ground")
export(String) var wound_sound = ""

func _ready():
	pass
	
func get_type():
	return type
	
func set_battle_id(id):
	battle_id = id

func get_battle_id():
	return battle_id
	
func on_attack():
	if has_node("sound"):
		get_node("sound").play(wound_sound)