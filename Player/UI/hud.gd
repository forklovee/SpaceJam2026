class_name HUD extends Control

@onready var score_label: Label = $ScoreLabel
@onready var time_label: Label = $TimeLabel
@onready var rad_debug_info: Label = $RadDebugInfo

@onready var status_bar: StatusBar = $StatusBar

@onready var radiation_icons: RadiationIcons = $RadiationIcons
@onready var storage_label: Label = $WeaponAmmo/VBoxContainer/Storage
@onready var weapon_ammo: WeaponAmmo = $WeaponAmmo

func bind_ship(ship: Ship):
	status_bar.bind(ship)
	weapon_ammo.bind(ship)
	
	ship.storage_changed.connect(_on_storage_changed)
	_on_storage_changed(ship)

func unbind_ship(ship: Ship):
	status_bar.unbind(ship)
	weapon_ammo.unbind(ship)
	
	ship.storage_changed.disconnect(_on_storage_changed)


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

var b1:Node3D
var b2:Node3D
func show_repair_munu(_b1:Node3D,_b2:Node3D):
	$Equipment_menu.visible=true
	b1=_b1
	b2=_b2

func can_tab(f=true):
	if f:
		if !$Equipment_menu.visible:
			$Equipment_popup.visible=true
	else:
		$Equipment_popup.visible=false
	
func _process(delta: float) -> void:
	if $Equipment_menu.visible:
		if !(is_instance_valid(b1) and is_instance_valid(b2)):
			$Equipment_menu.visible=false
		if b1.global_position.distance_to(b2.global_position)>23.0:
			$Equipment_menu.visible=false
