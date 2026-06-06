extends StaticBody3D

class_name  Cristal

var hp=1

func hit(damage,owner):
	hp-=damage
	if hp<=0:
		if not is_queued_for_deletion():
			owner.collect()
			self.queue_free()
