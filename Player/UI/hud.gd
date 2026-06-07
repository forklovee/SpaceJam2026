class_name HUD extends Control

@onready var score_label: Label = $ScoreLabel
@onready var time_label: Label = $TimeLabel
@onready var rad_debug_info: Label = $RadDebugInfo

@onready var health_label: Label = $ShipStats/VBoxContainer/Health
@onready var shield_label: Label = $ShipStats/VBoxContainer/Shield
@onready var fuel_label: Label = $ShipStats/VBoxContainer/Fuel
@onready var storage_label: Label = $ShipStats/VBoxContainer/Storage

@onready var regular_ammo: AmmoTypeGauge = $ShipStats/VBoxContainer/GridContainer/RegularAmmo
@onready var plsl_ammo: AmmoTypeGauge = $ShipStats/VBoxContainer/GridContainer/PLSLAmmo
@onready var rocket_ammo: AmmoTypeGauge = $ShipStats/VBoxContainer/GridContainer/RocketAmmo
@onready var railgun_ammo: AmmoTypeGauge = $ShipStats/VBoxContainer/GridContainer/RailgunAmmo

func bind_ship(ship: Ship):
	ship.health_changed.connect(_on_health_changed)
	ship.shield_changed.connect(_on_shield_changed)
	ship.fuel_changed.connect(_on_fuel_changed)
	ship.storage_changed.connect(_on_storage_changed)
	ship.used_weapon.connect(_on_ammo_amount_changed)
	_on_health_changed(ship)
	_on_shield_changed(ship)
	_on_fuel_changed(ship)
	_on_storage_changed(ship)
	
	_on_ammo_amount_changed(ship, Bullet3D.Type.Regular)
	_on_ammo_amount_changed(ship, Bullet3D.Type.PLSL)
	_on_ammo_amount_changed(ship, Bullet3D.Type.Rocket)
	_on_ammo_amount_changed(ship, Bullet3D.Type.Railgun)

func unbind_ship(ship: Ship):
	ship.health_changed.disconnect(_on_health_changed)
	ship.shield_changed.disconnect(_on_shield_changed)
	ship.fuel_changed.disconnect(_on_fuel_changed)
	ship.storage_changed.disconnect(_on_storage_changed)
	ship.used_weapon.disconnect(_on_ammo_amount_changed)


func update_labels():
	if !Game.pc.ship: return
	var rad_type := Game.pc.ship.radiation_query.data
	if rad_type.is_empty():
		return
	rad_debug_info.update(rad_type)

func _on_player_score_changed():
	score_label.update()

func _on_health_changed(ship: Ship):
	health_label.text = "Health: "+str(ship.health)+"/"+str(ship.max_health)

func _on_shield_changed(ship: Ship):
	shield_label.text = "Shield: "+str(ship.shield)+"/"+str(ship.max_shield)
	
func _on_fuel_changed(ship: Ship):
	fuel_label.text = "Fuel: "+str(ship.fuel)+"/"+str(ship.max_fuel)
	
func _on_storage_changed(ship: Ship):
	storage_label.text = "Storage: "+str(ship.storage)+"/"+str(ship.max_storage)

func _on_ammo_amount_changed(ship: Ship, ammo_type: Bullet3D.Type):
	match ammo_type:
		Bullet3D.Type.Regular:
			regular_ammo.update_amount(ship, ammo_type)
		Bullet3D.Type.PLSL:
			plsl_ammo.update_amount(ship, ammo_type)
		Bullet3D.Type.Rocket:
			rocket_ammo.update_amount(ship, ammo_type)
		Bullet3D.Type.Railgun:
			railgun_ammo.update_amount(ship, ammo_type)
	
