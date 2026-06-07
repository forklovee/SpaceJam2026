class_name Gun extends Node3D

@export_range(1, 3) var level: int = 1
@export var bullet_type: Bullet3D.Type

@export var target_gun_slots: Array[GunSlot.GunSlotTargets] = [GunSlot.GunSlotTargets.Nose]

@export var damage: int = 5
@export var range: float = 2.0
@export var firerate_sec: float = 0.1
@export var bullet_speed: float = 10.0
@export var max_ammo: int = 100
var ammo := max_ammo

var last_shoot_time: int = -1

func _ready() -> void:
	ammo = max_ammo

func has_ammo() -> bool:
	return ammo > 0

func can_shoot() -> bool:
	return has_ammo() && (Time.get_ticks_msec() - last_shoot_time) * 0.001 > firerate_sec

func shoot(instigator: Ship):
	if !can_shoot():
		return
	
	last_shoot_time = Time.get_ticks_msec()
	
	var bullet: Bullet3D = Data.get_bullet_resource(bullet_type).instantiate()
	Game.level.add_child(bullet)
	ammo -= 1
	
	var slot := instigator.get_gun_slot(GunSlot.GunSlotTargets.Nose)
	bullet.global_transform = slot.global_transform
	bullet.shoot(instigator, damage, range, bullet_speed*instigator.get_forward())
