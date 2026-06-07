class_name EnemyController extends Node

enum Task{
	Gather,
	Combat
}

@export var sight_collision_shape: CollisionShape3D

var ship: Ship
var task: Task = Task.Gather
var nervousness: float = 0.0

var bodies_in_sight: Array[Node3D]

func _ready() -> void:
	possess(get_parent())

func _process(delta: float) -> void:
	if !ship:
		return
	
	match task:
		Task.Gather:
			_gather_task(delta)
		Task.Combat:
			_combat_task(delta)

func _gather_task(delta: float):
	# TODO: fly to resources
	
	if !bodies_in_sight.is_empty():
		var global_position: Vector3 = ship.global_position
		var avg_distance_to_bodies: float = bodies_in_sight.reduce(
			func(accum, body): return accum+global_position.distance_to(body.global_position),
			0.0) / bodies_in_sight.size()
		
		var max_sight_range: float = 4.0
		if sight_collision_shape:
			max_sight_range = sight_collision_shape.shape.radius
		
		var distance_ratio: float = clamp(avg_distance_to_bodies/max_sight_range, 0.0, 1.0)
		nervousness = clamp(lerp(nervousness, nervousness+distance_ratio, 0.5*delta), 0.0, 1.0)
		#print(nervousness)
	else:
		nervousness = lerp(nervousness, 0.0, delta)
	
	if nervousness >= 1.0:
		task = Task.Combat

func _combat_task(delta: float):
	var global_position := ship.global_position
	var nearest_target = bodies_in_sight.reduce(
		func(nearest, body): 
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


func _on_sight_sense_body_entered(body: Node):
	if body in bodies_in_sight || !body.is_in_group(&"PlayerShip"):
		return
	bodies_in_sight.append(body)
	body.tree_exiting.connect(_on_sight_sense_body_destroyed.bind(body))

func _on_sight_sense_body_destroyed(body: Node):
	if body in bodies_in_sight:
		bodies_in_sight.erase(body)

func _on_sight_sense_body_exited(body: Node):
	if task == Task.Combat: return
	if body in bodies_in_sight:
		bodies_in_sight.erase(body)
