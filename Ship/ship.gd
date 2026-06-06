class_name Ship extends RigidBody3D

signal health_changed(ship: Ship)
signal storage_changed(ship: Ship)
signal fuel_changed(ship: Ship)

@export var max_health: int = 100
var health: int = max_health
@export var max_storage: int = 10
var storage: int = 0
@export var max_fuel: int = 100
var fuel: int = max_fuel

@export_group("Movement")
@export var speed: float = 20.0

var steering_direction: Vector2
var movement_direction: Vector2

func _physics_process(delta: float) -> void:
	var current_angle: float = rotation.y
	var target_angle: float = lerp_angle(current_angle, steering_direction.angle(), 2.0*delta) 
	
	if movement_direction.length() > 0.01:
		apply_central_force(20.0*get_forward())
	
	# y rotation
	apply_torque(50.0*Vector3.UP * angle_difference(current_angle, target_angle))	

func get_forward() -> Vector3:
	return -global_basis.z

# y-axis: forward-back
# x-axis: sides
func move(input_direction: Vector2):
	movement_direction = input_direction

func steer(input_direction: Vector2):
	# fix axises
	input_direction = Vector2(
		input_direction.y,
		-input_direction.x
	)
	
	if input_direction.length() > 0.01:
		move(Vector2.UP)
	else:
		move(Vector2.ZERO)
	
	var pre_target_direction = (steering_direction + input_direction).normalized()
	steering_direction = steering_direction.lerp(
		pre_target_direction, 0.1
	)


func damage(instigator: Node3D, damage: int):
	health_changed.emit(self)

func heal(instigator: Node3D, value: int):
	health_changed.emit(instigator)

func is_storage_full() -> bool:
	return storage == max_storage

func can_gather_crystals(amount: int) -> bool:
	return storage + amount <= max_storage

#TODO: define crystal piece
func gather_crystal(crystal_piece: Node3D, amount: int):
	if can_gather_crystals(amount):
		return
	
	if !crystal_piece.is_inside_tree():
		printerr(self, ": gather_crystal: crystal piece on inside tree!")
		return
	
	storage = clamp(storage+amount, 0, max_storage)
	storage_changed.emit(self)

func can_use_fuel(value: int) -> bool:
	return fuel - value >= 0

func use_fuel(value: int):
	if !can_use_fuel(value):
		return
	fuel = clamp(fuel-value, 0, max_fuel)
	fuel_changed.emit(self)
