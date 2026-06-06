extends Node

func _ready() -> void:
	$Label2.text="(your score X enemy score Y)".replace("X",str(Game.player_score)).replace("Y",str(Game.enemy_score))

func _on_button_pressed() -> void:
	Game.player_score=0
	Game.enemy_score=0
	
	get_tree().change_scene_to_file("res://main.tscn")
