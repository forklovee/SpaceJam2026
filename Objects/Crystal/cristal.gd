class_name Crystal extends StaticBody3D

signal gathered(ship: Ship)

@onready var collision: CollisionShape3D = $CollisionShape3D

@export var durability := 1

func _ready() -> void:
	Game.level_end.cristal_left+=1
	Game.level_end.cristal_total+=1

func damage(instigator: Ship, value: int):
	durability -= value
	if durability <= 0:
		if instigator.can_collect(value):
			Game.level_end.cristal_left-=1
			_destroy(instigator)

func _destroy(instigator: Ship):
	collision.disabled = true
	queue_free()
	gathered.emit(instigator)
	instigator.gather_crystal(self,1)
	print(instigator.storage)
