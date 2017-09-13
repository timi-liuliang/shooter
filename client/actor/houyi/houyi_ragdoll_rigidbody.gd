extends RigidBody2D

var actor_node = null
var ragdoll_node = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func set_root(actor_node_, ragdoll_node_):
	actor_node = actor_node_
	ragdoll_node = ragdoll_node_
	
func on_attack( offset, impulse):
	print("-------------------------------")
	actor_node.on_attack()
	ragdoll_node.switch_to_rigid_mode()
	self.apply_impulse( offset, impulse)
