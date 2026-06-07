extends Node

var bullets: Dictionary[Bullet3D.Type, PackedScene] = {
	Bullet3D.Type.Regular: ResourceLoader.load("res://Ship/Gun/Bullets/regular_bullet.tscn"),
	Bullet3D.Type.PLSL: ResourceLoader.load("res://Ship/Gun/Bullets/plsl_bullet.tscn"),
	Bullet3D.Type.Rocket: ResourceLoader.load("res://Ship/Gun/Bullets/rocket_bullet.tscn")
	#Bullet3D.Type.Railgun: ResourceLoader.load("res://Ship/Gun/Bullets/regular_bullet.tscn")
}

var cristal_shard = ResourceLoader.load( "res://Objects/Crystal/CristalShard/cristal_shard.tscn")

func get_bullet_resource(ammo_type: Bullet3D.Type) -> PackedScene:
	return bullets[ammo_type]
