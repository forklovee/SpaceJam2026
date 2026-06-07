extends StaticBody3D

var ship_owner=null

var ships: Array[Ship]

func _ready() -> void:
	set_process(false)
	add_to_group(&"CrystalShard")

func _process(delta: float) -> void:
	if ships.is_empty():
		set_process(false)
		return
	
	var target_ship := ships[0]
	var target_position: Vector3 = target_ship.global_position
	global_position = global_position.lerp(target_position, delta*15.0)
	if target_position.distance_to(global_position) < 0.5:
		target_ship.gather_crystal(self, 1)
		queue_free()
		set_process(false)

func _on_pick_up_area_body_entered(body: Node3D) -> void:
	if body is Ship && !(body in ships):
		ships.append(body)
		body.tree_exiting.connect(_on_pick_up_area_body_exited.bind(body))
		set_process(true)
		

func _on_pick_up_area_body_exited(body: Node3D) -> void:
	if body in ships:
		ships.erase(body)
	if ships.is_empty():
		set_process(false)
