class_name Ship extends RigidBody3D

signal health_changed(ship: Ship)
signal shield_changed(ship: Ship)
signal died(ship: Ship)
signal storage_changed(ship: Ship)
signal fuel_changed(ship: Ship)

signal used_weapon(ship: Ship)

@onready var base_gun_slot: GunSlot = $BaseGunSlot
@onready var radiation_query: RadiationQuery = $RaddiationQuerry

@export var max_health: int = 100
var health: int = max_health
@export var max_shield: int = 100
var shield: int = 0
@export var max_storage: int = 10
var storage: int = 0
@export var max_fuel: int = 100
var fuel: int = max_fuel

@export_group("Movement")
@export var speed: float = 20.0

var weapons: Array[Gun] = []

var steering_direction: Vector2
var movement_direction: Vector2

func _ready() -> void:
	update_weapons()

func _physics_process(delta: float) -> void:
	radiation_query.update()
	
	var current_angle: float = rotation.y
	var target_angle: float = lerp_angle(current_angle, steering_direction.angle(), 2.0*delta) 
	
	if movement_direction.length() > 0.01:
		apply_central_force(15.0*get_forward())
	
	# y rotation
	apply_torque(100.0*Vector3.UP * angle_difference(current_angle, target_angle))	

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

func update_weapons():
	weapons = []
	for slot in get_children().filter(func(ch): return ch is GunSlot):
		if slot.get_child_count() > 0 && slot.get_child(0) is Gun:
			weapons.append(slot.get_child(0))

func get_gun_of_ammo_type(bullet_type: Bullet3D.Type) -> Gun:
	var weapon_id := weapons.find_custom(func(gun): return gun.bullet_type == bullet_type)
	return weapons[weapon_id] if weapon_id > -1 else null

func get_max_ammo_count(bullet_type: Bullet3D.Type) -> int:
	var gun: Gun = get_gun_of_ammo_type(bullet_type)
	return gun.max_ammo if gun != null else 0

func get_ammo_count(bullet_type: Bullet3D.Type) -> int:
	var gun: Gun = get_gun_of_ammo_type(bullet_type)
	return gun.ammo if gun != null else 0

func shoot(weapon_id: int):
	if weapon_id > weapons.size():
		printerr(self, " ", weapon_id, " out of bounds")
		return
	var weapon: Gun = weapons[weapon_id]
	weapon.shoot(self)
	used_weapon.emit(self, weapon.bullet_type)

func damage(instigator: Node3D, value: int):
	health = clamp(health-value, 0, max_health)
	print(self, "(", health, "/", max_health,")"," damaged by ", instigator, " with ", value, "DMG")
	health_changed.emit(self) 
	if health <= 0:
		_on_died()

func _on_died():
	died.emit(self)
	queue_free()

func heal(instigator: Node3D, value: int):
	health = clamp(health+value, 0, max_health)
	print(self, "(", health, "/", max_health,")", " healt by ", instigator, " with ", value, "HP")
	health_changed.emit(self)
	if health <= 0:
		_on_died()
	health_changed.emit(instigator)

func add_shield(instigator: Node3D, value: int):
	shield = clamp(shield+value, 0, max_shield)
	print(self, "(", shield, "/", max_shield,")", " shield by ", instigator, " with ", value)
	shield_changed.emit(self)


func is_storage_full() -> bool:
	return storage == max_storage

func can_gather_crystals(amount: int) -> bool:
	return storage + amount <= max_storage

#TODO: define crystal piece
func gather_crystal(crystal_piece: Node3D, amount: int):
	if !can_gather_crystals(amount):
		return
	
	if crystal_piece && !crystal_piece.is_inside_tree():
		printerr(self, ": gather_crystal: crystal piece on inside tree!")
		return
	
	storage = clamp(storage+amount, 0, max_storage)
	print(self, " gathered ", amount, " crystals. Has: ", storage, "/", max_storage)
	
	storage_changed.emit(self)

func can_use_fuel(value: int) -> bool:
	return fuel - value >= 0

func use_fuel(value: int):
	if !can_use_fuel(value):
		return
	fuel = clamp(fuel-value, 0, max_fuel)
	fuel_changed.emit(self)
