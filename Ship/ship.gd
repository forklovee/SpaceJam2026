class_name Ship extends RigidBody3D

signal health_changed(ship: Ship)
signal shield_changed(ship: Ship)
signal died(ship: Ship)
signal storage_changed(ship: Ship)
signal fuel_changed(ship: Ship)

signal used_weapon(ship: Ship)

@onready var radiation_query: RadiationQuery = $RaddiationQuerry

@export var max_health: int = 100
var health: int = max_health
@export var max_shield: int = 100
var shield: int = 0
@export var max_storage: int = 10
var storage: int = 0
@export var max_fuel: float = 100.0
var fuel: float = max_fuel

@export_group("Movement")
@export var speed: float = 12.0

var weapons: Array[Gun] = []
var gun_slots: Dictionary[GunSlot.GunSlotTargets, GunSlot] = {}

var steering_direction: Vector2
var movement_direction: Vector2

func _ready() -> void:
	health = max_health
	shield = max_shield
	storage = 0#max_storage
	fuel = max_fuel
	update_weapons_and_gunslots()

func _physics_process(delta: float) -> void:
	radiation_query.update()
	radiation_process(delta)
	
	var current_angle: float = rotation.y
	var target_angle: float = lerp_angle(current_angle, steering_direction.angle(), 2.0*delta) 
	apply_central_force(15.0*Vector3(radiation_query.f.x, 0, radiation_query.f.y))
	if movement_direction.length() > 0.01:
		apply_central_force(15.0*Vector3(movement_direction.x, 0, movement_direction.y))
		if self.is_in_group("PlayerShip"): #TODO ememies use fuel
			use_fuel(delta*10.0)
	# y rotation
	apply_torque(250.0*Vector3.UP * angle_difference(current_angle, target_angle))	

	if fuel<=0.0:
		queue_free()

func radiation_process(delta):
	var e_fuel=300.0*delta*radiation_query.data[Star3D.RaditionType.FUEL_BEAM]
	fuel+=e_fuel
	
	var fuel=30.0*delta*radiation_query.data[Star3D.RaditionType.FUEL]
	self.use_fuel(-fuel)
	var sh=30.0*delta*radiation_query.data[Star3D.RaditionType.SHILD]
	self.add_shield(self,1 if randf()<sh else 0)
	var tok=30.0*delta*radiation_query.data[Star3D.RaditionType.TOKSIC]
	self.damage(self,4 if randf()<tok else 0)
	var amm=10.0*delta*radiation_query.data[Star3D.RaditionType.AMMO]
	if randf()<amm:
		for w in weapons:
			if w.name=="PLSLGun":
				w.ammo=min(w.ammo+1,w.max_ammo)
				Game.pc.hud._on_ammo_amount_changed(self,Bullet3D.Type.PLSL)

func get_forward() -> Vector3:
	return -global_basis.z

# y-axis: forward-back
# x-axis: sides
func move(input_direction: Vector2):
	movement_direction = Vector2(input_direction.x, -input_direction.y)

func steer(input_direction: Vector2):
	# fix axises
	input_direction = Vector2(
		input_direction.y,
		-input_direction.x
	)
	
	var pre_target_direction = (steering_direction + input_direction).normalized()
	steering_direction = steering_direction.lerp(
		pre_target_direction, 0.1
	)

func update_weapons_and_gunslots():
	weapons = []
	gun_slots = {}
	for slot in get_children().filter(func(ch): return ch is GunSlot):
		slot = slot as GunSlot
		gun_slots[slot.type] = slot
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

func get_gun_slot(gun_slot_enum: GunSlot.GunSlotTargets) -> GunSlot:
	return gun_slots.get(gun_slot_enum, null)

func shoot(weapon_id: int):
	if radiation_query.data[Star3D.RaditionType.PACE]>1.0:
		return
	if weapon_id >= weapons.size():
		return
	var weapon: Gun = weapons[weapon_id]
	weapon.shoot(self)
	used_weapon.emit(self, weapon.bullet_type)

func damage(instigator: Node3D, value: int):
	if shield<=0:
		health = clamp(health-value, 0, max_health)
		#print(self, "(", health, "/", max_health,")"," damaged by ", instigator, " with ", value, "DMG")
		health_changed.emit(self) 
		if health <= 0:
			_on_died()
	else:
		shield-=value
		shield_changed.emit(self)
	
	
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
	#print(self, "(", shield, "/", max_shield,")", " shield by ", instigator, " with ", value)
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

#TODO: oddawanie kryształów (metoda!)
func transfer_crystal():
	storage_changed.emit(self)

func can_use_fuel(value: int) -> bool:
	return fuel - value >= 0

func use_fuel(value: float):
	if !can_use_fuel(value):
		return
	fuel = clamp(fuel-value, 0, max_fuel)
	fuel_changed.emit(self)

func can_collect(value):
	return storage+value<=max_storage

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		if is_instance_valid(Data):
			for st in range(storage):
				var p=self.global_position
				var a=randf()*2*PI
				p+=Vector3(sin(a),0.0,cos(a))*0.3
				var s:Node3D=Data.cristal_shard.instantiate()
				Game.level.add_child(s)#.call_deferred(s)
				s.global_position=p
				s.scale=Vector3(1,1,1)*0.2
				
			self.storage=0
