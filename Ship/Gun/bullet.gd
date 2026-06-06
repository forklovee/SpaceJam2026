class_name Bullet3D extends Area3D

const AUTOKILL_TIME: float = 3.0

var instigator = null
var velocity: Vector3

var spawn_time: int

func _ready() -> void:
	spawn_time = Time.get_ticks_msec()

func shoot(new_instigator: Node3D, new_velocity: Vector3):
	instigator = new_instigator
	velocity = new_velocity

func _process(delta: float) -> void:
	if instigator == null:
		return
	
	if is_queued_for_deletion():
		return
	if (Time.get_ticks_msec() - spawn_time) * 0.001 > AUTOKILL_TIME:
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
	body.damage(instigator, 1)
