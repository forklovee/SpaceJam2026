extends Node

@export var menu:PackedScene

func _ready() -> void:
	Game.level_end=self
	
var cristal_left=0
var cristal_total=0

func _process(delta: float) -> void:
	if cristal_left==0 and cristal_total>0:
		#get_tree().change_scene_to_file("res://MainMenu/win.tscn")
		Game.open_level(menu)
