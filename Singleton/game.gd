extends Node

signal player_score_changed
signal enemy_score_changed

var pc: PlayerController
var level: Level

var level_end=null

var player_score := 0:
	set(value):
		player_score = value
		player_score_changed.emit()
var enemy_score := 0:
	set(value):
		enemy_score = value
		enemy_score_changed.emit()

func _ready() -> void:
	# Create PlayerController
	pc = PlayerController.new()
	add_child(pc)

func open_level(level_scene: PackedScene) -> Level:
	assert(level_scene)
	if is_instance_valid(level):
		level.queue_free()
	
	level = level_scene.instantiate()
	add_child(level)
	
	return level


func spawn_explosion(instigator: Ship, damage: int, max_range: float, target_position: Vector3):
	var explosion: Bullet3D = Data.get_bullet_resource(Bullet3D.Type.RocketExplosion).instantiate()
	level.call_deferred("add_child", explosion)
	if !explosion.is_inside_tree():
		await explosion.tree_entered
	explosion.global_position = target_position
	explosion.shoot(instigator, null, damage, max_range, Vector3.ZERO)
