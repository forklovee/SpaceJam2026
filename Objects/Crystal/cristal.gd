class_name Crystal extends StaticBody3D

signal gathered(ship: Ship)

@onready var collision: CollisionShape3D = $CollisionShape3D

@export var durability := 1
@onready var current_durability = durability
@export var value := 1

func _ready() -> void:
	Game.level_end.cristal_left+=1
	Game.level_end.cristal_total+=1

func damage(instigator: Ship, demage_value: int):
	current_durability -= demage_value
	if current_durability <= 0:
		if durability==1:
			if instigator.can_collect(demage_value):
				Game.level_end.cristal_left-=1
				_destroy(instigator)
		else:
			for v in range(value):
				var p=self.global_position
				var a=randf()*2*PI
				p+=Vector3(sin(a),0.0,cos(a))*0.3
				var s:Node3D=Data.cristal_shard.instantiate()
				Game.level.add_child(s)
				s.global_position=p
				s.ship_owner=instigator
			Game.level_end.cristal_left-=1
			queue_free()
	else:
		if $crack!=null:
			var m:StandardMaterial3D=$crack.get_surface_override_material(0)
			var alpha=1.0-current_durability/(durability-1.0)
			var alb=m.albedo_color
			alb.a=alpha
			m.albedo_color=alb
			$crack.visible=true
			$crack.set_surface_override_material(0,m)
			
func _destroy(instigator: Ship):
	if is_instance_valid(instigator):
		instigator.gather_crystal(null, 1)
	
	collision.disabled = true
	queue_free()
	gathered.emit(instigator)
	#instigator.gather_crystal(self,1)
	print(instigator.storage)

func _exit_tree() -> void:
	var e:AnimatedSprite3D=Data.exp.instantiate()
	Game.level.add_child(e)
	e.global_position=self.global_position
	e.play()
	#var f=func():e.queue_free()
	#e.animation_finished.connect(f)
