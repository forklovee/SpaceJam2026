class_name Bullet3D extends Area3D

enum Type{
	Regular,
	PLSL,
	Rocket,
	RocketExplosion,
	Railgun
}

var instigator = null
var velocity: Vector3
var damage: int
var max_range: float

var start_position: Vector3

func _get_material() -> StandardMaterial3D:
	return $MeshInstance3D.get_surface_override_material(0)

func shoot(new_instigator: Node3D, gun: Gun, new_damage: int, new_max_range: float, new_velocity: Vector3):
	instigator = new_instigator
	damage = new_damage
	max_range = new_max_range
	velocity = new_velocity
	start_position = global_position
	
	var material: StandardMaterial3D = Data.bullet_materials[gun.bullet_type].enemy_mat
	if instigator.is_in_group(&"PlayerShip"):
		match gun.level:
			1:
				material = Data.bullet_materials[gun.bullet_type].level1_mat
			2:
				material = Data.bullet_materials[gun.bullet_type].level2_mat
			3:
				material = Data.bullet_materials[gun.bullet_type].level3_mat
	$MeshInstance3D.set_surface_override_material(0, material)

func _process(delta: float) -> void:
	if is_queued_for_deletion():
		return
	if start_position.distance_to(global_position) > max_range:
		queue_free()
		return
	global_position += velocity*delta

func can_get_hurt(node: Node):
	return is_instance_valid(instigator) && is_instance_valid(node) &&\
			node.has_method("damage") && node.get_method_argument_count("damage") >= 2 &&\
			(instigator.is_in_group(&"EnemyShip") != node.is_in_group(&"EnemyShip") ||\
			instigator.is_in_group(&"PlayerShip") != node.is_in_group(&"PlayerShip"))

func _on_body_entered(body: Node3D) -> void:
	if body == instigator:
		return
	if !can_get_hurt(body):
		return
	
	if is_instance_valid(instigator):
		body.damage(instigator, damage)
	queue_free()
