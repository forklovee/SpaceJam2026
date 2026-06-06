class_name Crystal extends StaticBody3D

signal gathered(ship: Ship)

var hp=1

func destroy(ship: Ship):
	gathered.emit(ship)

func hit(damage,owner):
	hp-=damage
	if hp<=0:
		if not is_queued_for_deletion():
			owner.collect()
			self.queue_free()
