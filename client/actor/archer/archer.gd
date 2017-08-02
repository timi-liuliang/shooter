extends KinematicBody2D

var cur_anim = ""

func _ready():
	play_anim("idle")

func play_anim(anim):
	if cur_anim != anim:
		get_node("anim").play(anim)
		cur_anim = anim
		
func get_weapon_pos():
	var node = get_node("display/body/hand_right/weapon")
	return node.get_global_pos()

func get_weapon_rot():
	var node = get_node("display/body/hand_right/weapon")
	return node.get_global_rot()
	
func set_hand_rot(radian):
	get_node("display/body/hand_right").set_rot(radian)
	
func get_hand_rot():
	return get_node("display/body/hand_right").get_rot()