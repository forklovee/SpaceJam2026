class_name Gun extends Node3D

@export var bullet_res: PackedScene

@export var damage: int = 5
@export var firerate_sec: float = 0.1
@export var bullet_speed: float = 10.0
@export var max_ammo: int = 100
var ammo := max_ammo

var last_shoot_time: int = -1

func can_shoot() -> bool:
	return (Time.get_ticks_msec() - last_shoot_time) * 0.001 > firerate_sec

func shoot(instigator: Ship):
	if !can_shoot():
		return
	
	last_shoot_time = Time.get_ticks_msec()
	
	var bullet: Bullet3D = bullet_res.instantiate()
	Game.level.add_child(bullet)
	
	bullet.global_transform = global_transform
	bullet.shoot(instigator, bullet_speed*instigator.get_forward())
