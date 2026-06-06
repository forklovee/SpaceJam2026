extends Node

var pc: PlayerController
var level

func _ready() -> void:
	# Create PlayerController
	pc = PlayerController.new()
	add_child(pc)

func open_level(level_scene: PackedScene):
	if !level_scene:
		printerr(self, ":open_level: no level_scene provided!")
		return
	if is_instance_valid(level):
		level.queue_free()
	
	level = level_scene.instantiate()
	add_child(level)
