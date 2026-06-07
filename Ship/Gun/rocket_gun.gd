class_name RocketGun extends Gun

func shoot(instigator: Ship):
	if !can_shoot():
		return
	
	last_shoot_time = Time.get_ticks_msec()
	
	ammo -= 1
	
	var target_range := range
	var target_speed := bullet_speed
	match level:
		2:
			target_range *= 1.1
		3:
			target_range *= 1.1
			target_speed *= 1.05
	
	var left_wing_slot = instigator.get_gun_slot(GunSlot.GunSlotTargets.WingL)
	var right_wing_slot = instigator.get_gun_slot(GunSlot.GunSlotTargets.WingR)
	
	var bullet_res: PackedScene = Data.get_bullet_resource(bullet_type)
	for slot in [left_wing_slot, right_wing_slot]:
		var bullet: Bullet3D = bullet_res.instantiate()
		Game.level.add_child(bullet)
			
		bullet.global_transform = slot.global_transform
		var forward := instigator.get_forward()
		bullet.shoot(instigator, self, damage, target_range, target_speed*forward)
