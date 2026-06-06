class_name Crystal extends StaticBody3D

signal gathered(ship: Ship)

@onready var collision: CollisionShape3D = $CollisionShape3D

@export var durability := 1

func damage(instigator: Ship, value: int):
	durability -= value
	if durability <= 0:
		_destroy(instigator)

func _destroy(instigator: Ship):
	if is_instance_valid(instigator):
		instigator.gather_crystal(null, 1)
	
	collision.disabled = true
	queue_free()
	gathered.emit(instigator)
