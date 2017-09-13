extends Node2D

var max_blood = 100
var cur_blood = 100

var cur_anim = ""
var hand_rot = 0.0

var physics_collision_mask = 0
var physics_layer_mask = 0

func _ready():
	play_anim("idle")
	set_process(true)
	
func _process(delta):
	if has_node("ragdoll"):
		if !get_node("ragdoll").is_sleeping():
			get_node("normal").set_hidden(true)
		else:
			var rdPos = get_node("ragdoll").get_global_pos()
			set_pos(Vector2(rdPos.x, get_pos().y))
			get_node("normal").set_hidden(false)

func play_anim(anim):
	if cur_anim != anim:
		get_node("normal/anim").play(anim)
		print(anim)
		cur_anim = anim
		
func get_weapon_pos():
	var node = get_node("normal/display/gebo_2/shoubi_2/shou/weapon")
	return node.get_global_pos()

func get_weapon_rot():
	var node = get_node("normal/display/gebo_2/shoubi_2/shou/weapon")
	return node.get_global_rot()
	
func set_hand_rot(radian):
	if hand_rot != radian:
		play_anim("aim")
	
		var sec = rad2deg(radian) / 90.0 * 2
		get_node("normal/anim").seek( sec, true)
		get_node("normal/anim").stop(false)
		
		hand_rot = radian
	
func get_hand_rot():
	return get_node("normal/display/body").get_rot()
	
func on_attack():
	cur_blood = max(0, cur_blood - 35)
	
func disable_collision():
	physics_layer_mask = 0
	physics_collision_mask = 0
	if has_node("ragdoll"):
		get_node("ragdoll").set_layer_mask(0)
		get_node("ragdoll").set_collision_mask(0)
	
func set_layer_mask(mask):
	physics_layer_mask = mask
	if has_node("ragdoll"):
		get_node("ragdoll").set_layer_mask(mask)
	
#func set_layer_mask_bit(bit, value):
#	if value:
#		physics_layer_mask = 1 << bit
		
#	if has_node("ragdoll"):
#		get_node("ragdoll").set_layer_mask_bit(bit, value)
	
func set_collision_mask(mask):
	physics_collision_mask = mask
	if has_node("ragdoll"):
		get_node("ragdoll").set_collision_mask(mask)

#func set_collision_mask_bit(bit, value):
#	if has_node("ragdoll"):
#		get_node("ragdoll").set_collision_mask_bit(bit, value)
	
func get_weapon():
	return "res://actor/weapon/arrow.tscn"
	
func is_sleeping():
	if has_node("ragdoll"):
		return get_node("ragdoll").is_sleeping()
	else:
		return true
	
func set_mode(mode):
	pass

func is_mirror():
	if get_scale().x > 0.0:
		return false 
	else:
		return true
		
	
func remove_ragdoll():
	if has_node("ragdoll"):
		get_node("ragdoll").queue_free()	
	
func create_ragdoll():
	remove_ragdoll()
	
	var ragdoll = load("res://actor/houyi/houyi_ragdoll.tscn").instance()
	add_child(ragdoll)
	ragdoll.set_root(self)
	ragdoll.set_layer_mask(physics_layer_mask)
	ragdoll.set_collision_mask(physics_collision_mask)
	
