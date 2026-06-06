extends Node3D

@export var debug_player_ship: PackedScene
@export var debug_level: PackedScene

func _ready() -> void:
	Game.open_level(debug_level)
	Game.pc.spawn(Transform3D.IDENTITY, debug_player_ship)
