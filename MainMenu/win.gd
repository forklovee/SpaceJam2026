extends Node


func _on_button_pressed() -> void:
	Game.player_score=0
	Game.enemy_score=0
	get_tree().change_scene_to_file("res://main.tscn")
