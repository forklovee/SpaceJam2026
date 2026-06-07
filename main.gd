extends Node3D

@export var debug_player_ship: PackedScene
@export var debug_level: PackedScene

func _ready() -> void:
	var level = Game.open_level(debug_level)
	if !level.is_node_ready():
		await level.ready
	
	Game.pc.spawn(level.get_player_spawn_transform(), debug_player_ship)
