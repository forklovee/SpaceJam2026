class_name RocketBullet3D extends Bullet3D

var hit_before_kill: bool = false

func _on_body_entered(body: Node3D) -> void:
	if body == instigator:
		return
	if !can_get_hurt(body):
		return
	hit_before_kill = true
	body.damage(instigator, damage)
	Game.spawn_explosion(instigator, damage, max_range, global_position)
	queue_free()

func _exit_tree() -> void:
	if hit_before_kill:
		return
	Game.spawn_explosion(instigator, damage, max_range, global_position)
