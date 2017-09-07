extends KinematicBody2D

var max_blood = 100
var cur_blood = 100

var cur_anim = ""

func _ready():
	play_anim("idle")

func play_anim(anim):
	if cur_anim != anim:
		get_node("anim").play(anim)
		cur_anim = anim
		
func get_weapon_pos():
	var node = get_node("display/gebo_2/shoubi_2/shou")
	return node.get_global_pos()

func get_weapon_rot():
	var node = get_node("display/gebo_2/shoubi_2/shou")
	return node.get_global_rot()
	
func set_hand_rot(radian):
	get_node("display/body/yao").set_rot(radian)
	
func get_hand_rot():
	return get_node("display/body/yao").get_rot()
	
func set_weapon_hidden(hide):
	get_node("display/gebo_2/shoubi_2/shou").set_hidden(hide)
	
func on_attack():
	cur_blood = max(0, cur_blood - 35)

func is_mirror():
	if get_scale().x > 0.0:
		return false 
	else:
		return true