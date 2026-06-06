class_name PlayerController extends Node

const CAMERA_HEIGHT: float = 10.0

var _ship_scene: PackedScene

var input_direction: Vector2

var camera: Camera3D
var ship: Ship

func _ready() -> void:
	set_name("PlayerController")
	camera = ResourceLoader.load("res://Player/Camera/player_camera.tscn").instantiate()
	add_child(camera)
	camera.global_position.y = CAMERA_HEIGHT

func _process(delta: float) -> void:
	if !is_instance_valid(ship):
		return
	
	camera.global_position = camera.global_position.lerp(
		Vector3(ship.global_position.x, CAMERA_HEIGHT, ship.global_position.z), 10.0*delta
	)
	
	input_direction = Input.get_vector("Left", "Right", "Down", "Up")
	ship.move(input_direction)

func spawn(transform: Transform3D, new_ship_scene: PackedScene = null):
	destroy_ship()
	
	if new_ship_scene:
		_ship_scene = new_ship_scene
	
	ship = new_ship_scene.instantiate()
	add_child(ship)
	
	ship.global_transform = transform

func destroy_ship():
	if !is_instance_valid(ship):
		return
	ship.queue_free()
