extends Node3D

@export var bullet:PackedScene
@export var bullet_speed:float=1.0
var b:Bullet3D
@export var contorl_by_player=false
#func _ready() -> void:
#	b=bullet.instantiate()
	
func spawn():
	b=bullet.instantiate()
	Game.level.add_child(b)
	b.global_position=self.global_position
	b.velocity=(to_global(Vector3.FORWARD)-to_global(Vector3.ZERO))*bullet_speed

func _process(delta: float) -> void:
	
	if contorl_by_player:
		#print("AAAAAAAAAaafff")
		if Input.is_action_just_pressed("ui_accept"):
			#print("AAAAAAAAAaa")
			spawn()
