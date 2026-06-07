class_name RegularGun extends Gun

@export var bullets_per_shot: int = 3
@export_range(0.0, 90.0) var spread_deg: float = 45.0

func shoot(instigator: Ship):
	if !can_shoot():
		return
	
	last_shoot_time = Time.get_ticks_msec()
	
	ammo -= 1
	
	var target_range := range
	var target_damage := damage
	var target_speed := bullet_speed
	var target_spread := spread_deg
	match level:
		1:
			bullets_per_shot = 1
			target_spread = 0.0
		2:
			bullets_per_shot = 3
			target_range *= 1.1
			target_speed *= 1.05
		3:
			bullets_per_shot = 5
			target_damage *= 1.05
			target_range *= 1.1
			target_speed *= 1.05
	
	var angle_step_deg: float = (target_spread * 2.0) / bullets_per_shot
	var forward := instigator.get_forward().rotated(Vector3.UP, -deg_to_rad(target_spread))
	for i in range(bullets_per_shot):
		var bullet: Bullet3D = Data.get_bullet_resource(bullet_type).instantiate()
		Game.level.add_child(bullet)
		forward = forward.rotated(Vector3.UP, deg_to_rad(angle_step_deg))
		
		bullet.global_transform = Transform3D(
			instigator.global_basis,
			instigator.global_position + (0.2*forward)
		)
		bullet.shoot(instigator, target_damage, target_range, target_speed*forward)
