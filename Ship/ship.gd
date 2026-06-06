class_name Ship extends RigidBody3D

var steering_direction: Vector2
var movement_direction: Vector2

func _physics_process(delta: float) -> void:
	var current_angle: float = rotation.y
	var target_angle: float = lerp_angle(current_angle, steering_direction.angle(), 2.0*delta) 
	
	if movement_direction.length() > 0.01:
		apply_central_force(20.0*get_forward())
	
	# y rotation
	apply_torque(50.0*Vector3.UP * angle_difference(current_angle, target_angle))	

func get_forward() -> Vector3:
	return -global_basis.z

# y-axis: forward-back
# x-axis: sides
func move(input_direction: Vector2):
	movement_direction = input_direction

func steer(input_direction: Vector2):
	# fix axises
	input_direction = Vector2(
		input_direction.y,
		-input_direction.x
	)
	
	if input_direction.length() > 0.01:
		move(Vector2.UP)
	else:
		move(Vector2.ZERO)
	
	var pre_target_direction = (steering_direction + input_direction).normalized()
	steering_direction = steering_direction.lerp(
		pre_target_direction, 0.1
	)
