extends Node2D

var rigidbodys = []
var rigid_bodys_sleeping_check = []

func _ready():
	rigidbodys.append(get_node("body"))
	rigidbodys.append(get_node("body/tui_1"))
	rigidbodys.append(get_node("body/tui_1/jiao_1"))
	rigidbodys.append(get_node("body/tui_2"))
	rigidbodys.append(get_node("body/tui_2/jiao_2"))
	rigidbodys.append(get_node("body/gebo_1"))
	rigidbodys.append(get_node("body/gebo_2"))
	rigidbodys.append(get_node("body/gebo_2/shoubi_2"))
	
	rigid_bodys_sleeping_check.append(get_node("body"))
	
func set_root(actor_root):
	for rb in rigidbodys:
		rb.set_root(actor_root, self)
	
func switch_to_rigid_mode():
	for rb in rigidbodys:
		rb.set_mode(RigidBody2D.MODE_RIGID)
		rb.set_sleeping(false)

func set_layer_mask(mask):
	for rb in rigidbodys:
		rb.set_layer_mask(mask)
	
func set_layer_mask_bit(bit, value):
	for rb in rigidbodys:
		rb.set_layer_mask_bit(bit, value)
	
func set_collision_mask(mask):
	for rb in rigidbodys:
		rb.set_collision_mask(mask)

func set_collision_mask_bit(bit, value):
	for rb in rigidbodys:
		rb.set_collision_mask_bit(bit, value)
		
func is_sleeping():
	for rb in rigid_bodys_sleeping_check:
		if !rb.is_sleeping():
			return false
			
	return true
	
func get_foot_pos():
	return get_node("body/tui_1/jiao_1").get_global_pos() - get_global_pos()
	
func get_focus_pos():
	return get_node("body").get_global_pos()
