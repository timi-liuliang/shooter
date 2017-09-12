extends Node2D

var max_blood = 100
var cur_blood = 100

var cur_anim = ""

func _ready():
	play_anim("idle")

func play_anim(anim):
	if cur_anim != anim:
		get_node("normal/anim").play(anim)
		cur_anim = anim
		
func get_weapon_pos():
	var node = get_node("normal/display/gebo_2/shoubi_2/shou/weapon")
	return node.get_global_pos()

func get_weapon_rot():
	var node = get_node("normal/display/gebo_2/shoubi_2/shou/weapon")
	return node.get_global_rot()
	
func set_hand_rot(radian):
	print(rad2deg(radian))
	get_node("anim")
	
	get_node("normal/display/body").set_rot(radian)
	
func get_hand_rot():
	return get_node("normal/display/body").get_rot()
	
func set_weapon_hidden(hide):
	get_node("normal/display/gebo_2/shoubi_2/shou").set_hidden(hide)
	
func on_attack():
	cur_blood = max(0, cur_blood - 35)
	
func disable_collision():
	get_node("normal").set_layer_mask(0)
	get_node("normal").set_collision_mask(0)
	
func get_weapon():
	return "res://actor/weapon/arrow.tscn"

func is_mirror():
	if get_scale().x > 0.0:
		return false 
	else:
		return true