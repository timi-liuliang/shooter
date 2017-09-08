extends RigidBody2D

export(bool) var IsDisplayMirror = false

var max_blood = 100
var cur_blood = 100

var cur_anim = ""

func _ready():
	if IsDisplayMirror:
		get_node("display").set_scale(Vector2(-0.5, 0.5))
		
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
	
func set_weapon_hidden(hide):
	get_node("display/body/weapon_sprite").set_hidden(hide)
	
func on_attack():
	cur_blood = max(0, cur_blood - 35)

func is_mirror():
	if get_node("display").get_scale().x > 0.0:
		return false 
	else:
		return true