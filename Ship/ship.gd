class_name Ship extends RigidBody3D

var target_direction: Vector2

func _physics_process(delta: float) -> void:
	if target_direction.length() > 0.1:
		pass
	else:
		pass
	
	rotation.y = lerp_angle(rotation.y, target_direction.angle(), 2.0*delta)

func get_forward_2d() -> Vector2:
	return Vector2(
		-global_basis.z.x,
		-global_basis.z.z
	)

func move(input_direction: Vector2):
	# fix axises
	input_direction = Vector2(
		input_direction.y,
		-input_direction.x
	)
	
	var pre_target_direction = (target_direction + input_direction).normalized()
	target_direction = target_direction.lerp(
		pre_target_direction, 0.1
	)
