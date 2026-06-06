extends Node

signal player_score_changed
signal enemy_score_changed

var pc: PlayerController
var level

var player_score=0
var enemy_score=0
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

func open_level(level_scene: PackedScene):
	assert(level_scene)
	if is_instance_valid(level):
		level.queue_free()
	
	level = level_scene.instantiate()
	add_child(level)
