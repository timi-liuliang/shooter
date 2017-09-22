extends Node2D

var max_blood = 100
var cur_blood = 100

var cur_anim = ""
var hand_rot = 0.0

var is_ragdoll_active = false
var physics_collision_mask = 0
var physics_layer_mask = 0
export(bool) var is_mirror = false

func _ready():
	play_anim("idle")
	set_process(true)
	
	if is_mirror:
		get_node("normal").set_scale(Vector2(-1, 1))

func _process(delta):
	if is_ragdoll_active:
		if get_node("ragdoll").is_sleeping():
			deactive_ragdoll()

func active_ragdoll():
	is_ragdoll_active = true
	get_node("normal").set_hidden(true)
	get_node("ragdoll").set_hidden(false)
	
func deactive_ragdoll():
	is_ragdoll_active = false
	var rd_pos = get_node("ragdoll").get_foot_pos()
	print(rd_pos)
	set_pos(get_pos() + Vector2(rd_pos.x, 0.0))
	
	get_node("normal").set_hidden(false)

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
	if hand_rot != radian:
		play_anim("aim")
	
		var sec = rad2deg(radian) / 90.0 * 2
		get_node("normal/anim").seek( sec, true)
		get_node("normal/anim").stop(false)
		
		hand_rot = radian
	
func get_hand_rot():
	return get_node("normal/display/body").get_rot()
	
func on_attack():
	active_ragdoll()
	cur_blood = max(0, cur_blood - 35)
	
func get_focus_pos():
	if is_ragdoll_active:
		return get_node("ragdoll").get_focus_pos()
	else:
		return get_pos()
				
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
	
	
func set_collision_mask(mask):
	physics_collision_mask = mask
	if has_node("ragdoll"):
		get_node("ragdoll").set_collision_mask(mask)
	
func get_weapon():
	return "res://actor/weapon/arrow.tscn"
	
func is_sleeping():
	return !is_ragdoll_active;
	
func set_mode(mode):
	pass
	
func is_mirror():
	return is_mirror
		
func remove_ragdoll():
	if has_node("ragdoll"):
		get_node("ragdoll").queue_free()	
	
func create_ragdoll():
	remove_ragdoll()
	
	var ragdoll = null 
	if is_mirror():
		ragdoll = load("res://actor/houyi/houyi_ragdoll_mirror.tscn").instance()
	else:
		ragdoll = load("res://actor/houyi/houyi_ragdoll.tscn").instance()
		
	add_child(ragdoll)
	ragdoll.set_root(self)
	ragdoll.set_hidden(true)
	ragdoll.set_layer_mask(physics_layer_mask)
	ragdoll.set_collision_mask(physics_collision_mask)
	
func shoot():
	get_node("normal/sound").play("shoot")