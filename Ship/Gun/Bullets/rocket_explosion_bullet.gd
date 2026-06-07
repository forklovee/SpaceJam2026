extends Bullet3D

const DURATION_SEC: float = 1.0

var shoot_time: int

func _process(_delta: float) -> void:
	if (Time.get_ticks_msec() - shoot_time) * 0.001 > DURATION_SEC:
		queue_free()

func shoot(new_instigator: Node3D, new_damage: int, new_max_range: float, new_velocity: Vector3):
	instigator = new_instigator
	damage = new_damage
	max_range = new_max_range
	velocity = new_velocity
	shoot_time = Time.get_ticks_msec()
	show()
	
func _on_body_entered(body: Node3D) -> void:
	if body == instigator:
		return
	if !can_get_hurt(body):
		return
	body.damage(instigator, damage)
