class_name PlayerCamera extends Camera3D

const CAMERA_HEIGHT: float = 10.0

var follow_target: Node3D

func _physics_process(delta: float) -> void:
	if !is_instance_valid(follow_target):
		return
	
	global_position = global_position.lerp(
		Vector3(follow_target.global_position.x, CAMERA_HEIGHT, follow_target.global_position.z), 10.0*delta
	)
