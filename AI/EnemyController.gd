class_name EnemyController extends Node

enum Task{
	ReturnToBase,
	Gather,
	Search,
	Combat
}

@export var sight_collision_shape: CollisionShape3D

var ship: Ship
var task: Task = Task.Gather
var nervousness: float = 0.0

var bodies_in_sight: Array[Node3D]

var target_crystal: Crystal
var is_flying_to_search_position: bool = false
var search_position: Vector3

func _ready() -> void:
	possess(get_parent())

func _process(delta: float) -> void:
	if !ship:
		return
	
	match task:
		Task.ReturnToBase:
			_return_to_base_task(delta)
		Task.Search:
			_search_task(delta)
		Task.Gather:
			_gather_task(delta)
		Task.Combat:
			_combat_task(delta)

func _return_to_base_task(_delta: float):
	if ship.storage == 0:
		task = Task.Gather
		return
	if Game.level.enemy_base==null:
		return
	var enemy_base :Base= Game.level.enemy_base
	var global_position := ship.global_position
	var target_position := enemy_base.global_position
	var direction_to_target := global_position.direction_to(target_position)
	var move_direction := Vector2(
		direction_to_target.x,
		-direction_to_target.z
	)
	ship.steer(move_direction)
	if global_position.distance_to(target_position) > 1.0:
		ship.move(move_direction)
	else:
		ship.move(Vector2.ZERO)

func _gather_task(delta: float):
	if ship.storage >= 5:
		task = Task.ReturnToBase
		return
	
	if is_instance_valid(target_crystal):
		var global_position := ship.global_position*Vector3(1.0, 0.0, 1.0)
		var target_position := target_crystal.global_position*Vector3(1.0, 0.0, 1.0)
		var direction_to_target := global_position.direction_to(target_position)
		var move_direction := Vector2(
			direction_to_target.x,
			-direction_to_target.z
		)
		
		ship.steer(move_direction)
		
		if global_position.distance_to(target_position) > 2.0:
			ship.move(move_direction)
		else:
			ship.move(Vector2.ZERO)
			ship.shoot(0)
	else:
		if !Game.level is Level:
			return
		target_crystal = Game.level.register_target_crystal(ship)
	
	# probably all crystals are destroyed
	if target_crystal == null:
		task = Task.Search
		return
	
	if !bodies_in_sight.is_empty():
		var global_position: Vector3 = ship.global_position
		var avg_distance_to_bodies: float = bodies_in_sight.reduce(
			func(accum, body): return accum+global_position.distance_to(body.global_position),
			0.0) / bodies_in_sight.size()
		
		var max_sight_range: float = 4.0
		if sight_collision_shape:
			max_sight_range = sight_collision_shape.shape.radius
		
		var distance_ratio: float = clamp(avg_distance_to_bodies/max_sight_range, 0.0, 1.0)
		nervousness = clamp(lerp(nervousness, nervousness+distance_ratio, 0.75*delta), 0.0, 1.0)
	else:
		nervousness = lerp(nervousness, 0.0, delta)
	
	if nervousness >= 1.0:
		task = Task.Combat


func _search_task(_delta: float):
	var global_position := ship.global_position*Vector3(1.0, 0.0, 1.0)
	
	if ship.storage > 5:
		task = Task.ReturnToBase
		return
	
	if !is_flying_to_search_position:
		var crystal_shards := get_tree().get_nodes_in_group(&"CrystalShard")
		if !crystal_shards.is_empty():
			crystal_shards.sort_custom(
				func(a, b):
					return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position)
			)
			search_position = crystal_shards[0].global_position*Vector3(1.0, 0.0, 1.0)
			is_flying_to_search_position = true
			return
		if is_instance_valid(ship):
			search_position = ship.global_position
			is_flying_to_search_position = true
		else:
			is_flying_to_search_position = false
	
	var direction_to_target := global_position.direction_to(search_position)
	var move_direction := Vector2(
		direction_to_target.x,
		-direction_to_target.z
	)
	ship.move(move_direction)
	ship.steer(move_direction)
	if global_position.distance_to(search_position) < 1.5:
		is_flying_to_search_position = false
	
	if !bodies_in_sight.is_empty():
		task = Task.Combat
		return
	


func _combat_task(_delta: float):
	var global_position := ship.global_position
	var nearest_target = bodies_in_sight.reduce(
		func(nearest, body): 
			if !is_instance_valid(body):
				return nearest
			if nearest == null:
				return body
			var distance_nearest := global_position.distance_to(nearest.global_position)
			var distance_body := global_position.distance_to(body.global_position)
			if distance_nearest < distance_body:
				return nearest
			return body
			, null)
	
	if bodies_in_sight.is_empty():
		task = Task.Gather
		return
	
	var target_position: Vector3 = nearest_target.global_position
	target_position += 5.0*Vector3(
		sin(0.0005*Time.get_ticks_msec()),
		0.0,
		cos(0.0005*Time.get_ticks_msec())
	)
	var direction_to_target := global_position.direction_to(target_position)
	var move_direction := Vector2(
		direction_to_target.x,
		-direction_to_target.z
	)
	ship.move(move_direction)
	
	direction_to_target = global_position.direction_to(
		nearest_target.global_position).normalized()
	var look_direction := Vector2(
		direction_to_target.x,
		-direction_to_target.z
	)
	ship.steer(look_direction)
	
	var time := Time.get_ticks_msec()
	if time % 12 == 0:
		ship.shoot(0)

func possess(new_ship: Ship):
	ship = new_ship
	ship.got_damage.connect(_on_got_damage)
	ship.died.connect(_on_died)

func _on_died(_ship: Ship):
	bodies_in_sight = []

func _on_got_damage(_ship: Ship, instigator: Ship):
	if task == Task.Gather && instigator.is_in_group(&"PlayerShip"):
		bodies_in_sight = [instigator]
		task = Task.Combat

func _on_sight_sense_body_entered(body: Node):
	if body in bodies_in_sight || !body.is_in_group(&"PlayerShip"):
		return
	bodies_in_sight.append(body)
	if !body.tree_exited.is_connected(_on_sight_sense_body_destroyed):
		body.tree_exiting.connect(_on_sight_sense_body_destroyed.bind(body))

func _on_sight_sense_body_destroyed(body: Node):
	if body in bodies_in_sight:
		bodies_in_sight.erase(body)

func _on_sight_sense_body_exited(body: Node):
	if task == Task.Combat: return
	if body in bodies_in_sight:
		bodies_in_sight.erase(body)
