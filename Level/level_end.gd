extends Node

@export var menu:PackedScene

func _ready() -> void:
	Game.level_end=self
	
var cristal_left=0
var cristal_total=0

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_DELETE):
		Game.open_level(menu)
	
	if cristal_left==0 and cristal_total>0:
		#get_tree().change_scene_to_file("res://MainMenu/win.tscn")
		for eg in get_tree().get_nodes_in_group("EnemyShip"):
			if eg.storage>0:
				return
		for eg in get_tree().get_nodes_in_group("PlayerShip"):
			if eg.storage>0:
				return
		for c in get_tree().get_nodes_in_group("Crystal"):
			return
		Game.open_level(menu)
