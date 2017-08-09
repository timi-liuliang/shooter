extends Node

var start_pos = Vector2(0.0, 0.0)
var aim_degree = float(0.0)
var init_dir = Vector2(0.0, 0.0)
var init_speed = 0.0
var acc_velocity = Vector2(0.0, 0.0)

func _ready():
	pass
	
func set( start, degree, speed, acceleration):
	start_pos = start
	init_speed = speed
	acc_velocity = acceleration
	aim_degree = degree
	init_dir = Vector2(1,0).rotated(deg2rad(aim_degree))
	
func get_pos(shoot_time):
	var offset = init_speed * init_dir * shoot_time + 0.5 * acc_velocity  * shoot_time * shoot_time
	return start_pos + offset
	
func get_velocity(shoot_time):
	return init_speed * init_dir + shoot_time * acc_velocity
	
func get_init_velocity(start_pos, target_pos, acceleration):
	var init_velo = GetParableInitialVelocity( start_pos, target_pos, 0.0, acceleration)
	return init_velo
	
# Return initial velocity to reach a particular point in 2D
func GetParableInitialVelocity( origin, target, offsetY, acceleration):
	# Init trajectory variables
	var gravity = acceleration.y
	var height = abs(target.y - origin.y + offsetY)
	var dist = abs(target.x - origin.x)
	var vertVelocity = 0.0
	var time = 0.0
	var horzVelocity = 0.0
	  
	if (height < 0.1): 
		height = 0.1 # Prevents division by zero
	if (gravity < 0.1):
		 gravity = 0.1 # Prevents division by zero
	
	# If we are going upward
	# we will use a direct parable trajectory
	# and reach the highest point
	if (target.y - origin.y > 1.0):
		vertVelocity = 0.0
		time = sqrt(2 * height / gravity)
		horzVelocity = dist / time

	# If we are going downward
	# we will use a direct parable trajectory
	# with no vertical velocity
	elif (target.y - origin.y < -1.0):
		vertVelocity = sqrt(2.0 * gravity * height)
		time = vertVelocity / gravity
		horzVelocity = dist / time
	# Else we will follow a full parable
	# and determine the height of the jump
	# depending on the distance between the 2 points
	else:
		height = dist / 4
		vertVelocity = sqrt(2.0 * gravity * height)
		time = 2 * vertVelocity / gravity
		horzVelocity = dist / time
		
	if (vertVelocity == 0.0 && horzVelocity == 0.0):
		return Vector2(0.0, 0.0)
		
	# Jump right
	if(target.x - origin.x > 0.0 && !is_nan(vertVelocity) && !is_nan(horzVelocity)):
		return Vector2 (horzVelocity, -vertVelocity);
		
	# Jump left
	elif (!is_nan(vertVelocity) && !is_nan(horzVelocity)):
		return Vector2 (-horzVelocity, -vertVelocity);
	else:
		return Vector2(0.0, 0.0)