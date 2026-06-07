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

func shoot(new_instigator: Node3D, new_damage: int, new_max_range: float, new_velocity: Vector3):
	instigator = new_instigator
	damage = new_damage
	max_range = new_max_range
	velocity = new_velocity
	start_position = global_position

func _process(delta: float) -> void:
	if instigator == null:
		return
	
	if is_queued_for_deletion():
		return
	if start_position.distance_to(global_position) > max_range:
		queue_free()
		return
	
	global_position += velocity*delta

func can_get_hurt(node: Node):
	return node.has_method("damage") && node.get_method_argument_count("damage") >= 2

func _on_body_entered(body: Node3D) -> void:
	if body == instigator:
		return
	if !can_get_hurt(body):
		return
	body.damage(instigator, damage)
	queue_free()
