extends Node

class BulletColors extends RefCounted:
	var type: Bullet3D.Type
	
	var enemy_mat: StandardMaterial3D
	var level1_mat: StandardMaterial3D
	var level2_mat: StandardMaterial3D
	var level3_mat: StandardMaterial3D
	
	func _init(new_type: Bullet3D.Type, bullet_res: PackedScene):
		type = new_type
		var bullet: Bullet3D = bullet_res.instantiate()
		Data.add_child(bullet)
		var bullet_mat := bullet._get_material()
		if !bullet_mat:
			bullet.queue_free()
			return
		
		enemy_mat = bullet_mat.duplicate(true)
		enemy_mat.set("albedo_color", Color(1.0, 0.0, 0.0, 1.0))
		bullet.queue_free()
		
		level1_mat = enemy_mat.duplicate(true)
		level1_mat.set("albedo_color", Color(0.0, 0.967, 1.0, 1.0))
		level2_mat = enemy_mat.duplicate(true)
		level2_mat.set("albedo_color", Color(0.733, 0.0, 1.0, 1.0))
		level3_mat = enemy_mat.duplicate(true)
		level3_mat.set("albedo_color", Color(0.417, 1.0, 0.0, 1.0))
		

var bullets: Dictionary[Bullet3D.Type, PackedScene] = {}

var bullet_materials: Dictionary[Bullet3D.Type, BulletColors]

var cristal_shard = ResourceLoader.load( "res://Objects/Crystal/CristalShard/cristal_shard.tscn")

var enemies:Dictionary[EnemyRespawn.EnemyType, PackedScene] = {
	EnemyRespawn.EnemyType.Normal:ResourceLoader.load("res://Ship/EnemyShip/base_enemy_ship.tscn"),
	EnemyRespawn.EnemyType.Big:ResourceLoader.load("res://Ship/EnemyShip/big_enemy_ship.tscn")
	
}

var player_to_respawn = ResourceLoader.load( "res://Ship/PlayerShip/player_ship.tscn")

var exp=ResourceLoader.load("res://Arty/explode.tscn")

func _ready() -> void:
	bullets = {
		Bullet3D.Type.Regular: ResourceLoader.load("res://Ship/Gun/Bullets/regular_bullet.tscn"),
		Bullet3D.Type.PLSL: ResourceLoader.load("res://Ship/Gun/Bullets/plsl_bullet.tscn"),
		Bullet3D.Type.Rocket: ResourceLoader.load("res://Ship/Gun/Bullets/rocket_bullet.tscn"),
		Bullet3D.Type.RocketExplosion: ResourceLoader.load("res://Ship/Gun/Bullets/rocket_explosion_bullet.tscn")
		#Bullet3D.Type.Railgun: ResourceLoader.load("res://Ship/Gun/Bullets/regular_bullet.tscn")
	}
	for type in bullets.keys():
		if type == Bullet3D.Type.RocketExplosion: continue
		bullet_materials[type] = BulletColors.new(type, bullets[type])

func get_bullet_resource(ammo_type: Bullet3D.Type) -> PackedScene:
	return bullets[ammo_type]
