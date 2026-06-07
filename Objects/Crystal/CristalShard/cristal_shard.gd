extends StaticBody3D

var ship_owner=null

func _process(delta: float) -> void:
	if ship_owner==null:
		for b in $PickUpArea.get_overlapping_bodies():
			var body:PhysicsBody3D=b
			if body.is_in_group("EnemyShip"):
				if body.can_gather_crystals(1):
					ship_owner=body
			if body.is_in_group("PlayerShip"):
				if body.can_gather_crystals(1):
					ship_owner=body
	if ship_owner!=null:
		if !is_instance_valid(ship_owner):
			ship_owner=null
			return
		if !ship_owner.can_gather_crystals(1):
			ship_owner=null
			return
		self.global_position=lerp(self.global_position,ship_owner.global_position,delta)
		if self.global_position.distance_to(ship_owner.global_position)<1.0:
			ship_owner.gather_crystal(self,1)
			self.queue_free()
			
			
			
