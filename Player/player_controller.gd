class_name PlayerController extends Node

var _ship_scene: PackedScene

var input_direction: Vector2

var camera: PlayerCamera
var ship: Ship

func _ready() -> void:
	set_name("PlayerController")
	camera = ResourceLoader.load("res://Player/Camera/player_camera.tscn").instantiate()
	add_child(camera)

func _input(_event: InputEvent) -> void:
	if !is_instance_valid(ship):
		return

func _process(_delta: float) -> void:
	if !is_instance_valid(ship):
		return
	
	if Input.is_action_pressed("Fire"):
		ship.shoot()
	
	input_direction = Input.get_vector("Left", "Right", "Down", "Up")
	ship.steer(input_direction)


func spawn(transform: Transform3D, new_ship_scene: PackedScene = null):
	destroy_ship()
	
	if new_ship_scene:
		_ship_scene = new_ship_scene
	if !_ship_scene:
		printerr(self, ":spawn: No ship scene set!")
		return
	ship = _ship_scene.instantiate()
	add_child(ship)
	
	ship.global_transform = transform
	
	camera.follow_target = ship

func destroy_ship():
	if !is_instance_valid(ship):
		return
	ship.queue_free()
