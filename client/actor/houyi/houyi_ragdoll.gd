extends Node2D

var rigidbodys = []

func _ready():
	rigidbodys.append(get_node("body"))
	rigidbodys.append(get_node("body/tui_1"))
	rigidbodys.append(get_node("body/tui_1/jiao_1"))
	rigidbodys.append(get_node("body/tui_2"))
	rigidbodys.append(get_node("body/tui_2/jiao_2"))
	rigidbodys.append(get_node("body/gebo_1"))
	rigidbodys.append(get_node("body/gebo_1/shoubi_1"))
	rigidbodys.append(get_node("body/gebo_2"))
	rigidbodys.append(get_node("body/gebo_2/shoubi_2"))
	
func set_root(actor_root):
	for rb in rigidbodys:
		rb.set_root(actor_root, self)
	
func switch_to_rigid_mode():
	for rb in rigidbodys:
		rb.set_mode(RigidBody2D.MODE_RIGID)

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
	for rb in rigidbodys:
		if !rb.is_sleeping():
			return false
			
	return true
