extends Node

var pc: PlayerController
var level
var player_score=0
var enemy_score=0
var level_end=null





var RAD_FUEL=0.0
var RAD_SHILD=0.0
var RAD_AMMO=0.0
var RAD_PACE=0.0
var RAD_TOKSIC=0.0
var RAD_FUEL_BEAM=0.0







func _ready() -> void:
	# Create PlayerController
	pc = PlayerController.new()
	add_child(pc)

func open_level(level_scene: PackedScene):
	assert(level_scene)
	if is_instance_valid(level):
		level.queue_free()
	
	level = level_scene.instantiate()
	add_child(level)
