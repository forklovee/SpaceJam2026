class_name PLSLGun extends Gun

var shot_count = 0

func shoot(instigator: Ship):
	if !can_shoot():
		return
	
	last_shoot_time = Time.get_ticks_msec()
	
	ammo -= 1
	shot_count = (shot_count + 1) % 2
	
	var target_range := range
	var target_speed := bullet_speed
	match level:
		2:
			target_range *= 1.1
		3:
			target_range *= 1.1
			target_speed *= 1.05
	
	var target_slot: GunSlot = null
	if shot_count == 0:
		target_slot = instigator.get_gun_slot(GunSlot.GunSlotTargets.WingL)
	else:
		target_slot = instigator.get_gun_slot(GunSlot.GunSlotTargets.WingR)
	
	var bullet: Bullet3D = Data.get_bullet_resource(bullet_type).instantiate()
	Game.level.add_child(bullet)
		
	bullet.global_transform = target_slot.global_transform
	var forward := instigator.get_forward()
	bullet.shoot(instigator, self, damage, target_range, target_speed*forward)
