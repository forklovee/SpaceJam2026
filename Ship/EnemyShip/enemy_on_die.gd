extends Node


func _on_base_enemy_ship_died(ship: Ship) -> void:
	print("ENEMY DIE!!!!!!!!")
	Game.level.enemyRespawn.to_spawn+=1
