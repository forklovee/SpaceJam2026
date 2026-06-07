extends Node

var bullets: Dictionary[Bullet3D.Type, PackedScene] = {
	Bullet3D.Type.Regular: ResourceLoader.load("res://Ship/Gun/Bullets/regular_bullet.tscn"),
	Bullet3D.Type.PLSL: ResourceLoader.load("res://Ship/Gun/Bullets/plsl_bullet.tscn"),
	Bullet3D.Type.Rocket: ResourceLoader.load("res://Ship/Gun/Bullets/rocket_bullet.tscn"),
	Bullet3D.Type.RocketExplosion: ResourceLoader.load("res://Ship/Gun/Bullets/rocket_explosion_bullet.tscn")
	#Bullet3D.Type.Railgun: ResourceLoader.load("res://Ship/Gun/Bullets/regular_bullet.tscn")
}

var cristal_shard = ResourceLoader.load( "res://Objects/Crystal/CristalShard/cristal_shard.tscn")

var enemies:Dictionary[EnemyRespawn.EnemyType, PackedScene] = {
	EnemyRespawn.EnemyType.Normal:ResourceLoader.load("res://Ship/EnemyShip/base_enemy_ship.tscn"),
	EnemyRespawn.EnemyType.Big:ResourceLoader.load("res://Ship/EnemyShip/big_enemy_ship.tscn")
	
}

var player_to_respawn = ResourceLoader.load( "res://Ship/PlayerShip/player_ship.tscn")

func get_bullet_resource(ammo_type: Bullet3D.Type) -> PackedScene:
	return bullets[ammo_type]
