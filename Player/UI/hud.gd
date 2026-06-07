class_name HUD extends Control

@onready var score_label: Label = $ScoreLabel
@onready var time_label: Label = $TimeLabel
@onready var rad_debug_info: Label = $RadDebugInfo

@onready var status_bar: StatusBar = $StatusBar

@onready var radiation_icons: RadiationIcons = $RadiationIcons
@onready var storage_label: Label = $ShipStats/VBoxContainer/Storage

@onready var regular_ammo: AmmoTypeGauge = $ShipStats/VBoxContainer/GridContainer/RegularAmmo
@onready var plsl_ammo: AmmoTypeGauge = $ShipStats/VBoxContainer/GridContainer/PLSLAmmo
@onready var rocket_ammo: AmmoTypeGauge = $ShipStats/VBoxContainer/GridContainer/RocketAmmo
@onready var railgun_ammo: AmmoTypeGauge = $ShipStats/VBoxContainer/GridContainer/RailgunAmmo

func bind_ship(ship: Ship):
	status_bar.bind(ship)

	ship.storage_changed.connect(_on_storage_changed)
	ship.used_weapon.connect(_on_ammo_amount_changed)
	_on_storage_changed(ship)
	
	_on_ammo_amount_changed(ship, Bullet3D.Type.Regular)
	_on_ammo_amount_changed(ship, Bullet3D.Type.PLSL)
	_on_ammo_amount_changed(ship, Bullet3D.Type.Rocket)
	_on_ammo_amount_changed(ship, Bullet3D.Type.Railgun)

func unbind_ship(ship: Ship):
	status_bar.unbind(ship)
	
	ship.storage_changed.disconnect(_on_storage_changed)
	ship.used_weapon.disconnect(_on_ammo_amount_changed)


func update_labels():
	var ship := Game.pc.ship
	if !ship: return
	var rad_data := ship.radiation_query.data
	if rad_data.is_empty():
		return
	radiation_icons.update(ship, rad_data)
	rad_debug_info.update(rad_data)

func _on_player_score_changed():
	score_label.update()
	
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
	
