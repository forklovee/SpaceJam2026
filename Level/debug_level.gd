extends Level

func _ready() -> void:
	var big_ship := ResourceLoader.load("res://Ship/EnemyShip/base_enemy_ship.tscn")
	for i in range(10):
		var target_position := Vector3(
			sin(i * PI*0.1),
			0.0,
			cos(i * PI*0.1)
		)
		var ship = big_ship.instantiate()
		add_child(ship)
		ship.global_position = target_position
