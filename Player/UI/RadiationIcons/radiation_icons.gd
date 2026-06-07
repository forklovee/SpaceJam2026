class_name RadiationIcons extends Control

@onready var energy_icon: Control = $HBoxContainer/EnergyIcon
@onready var energy_beam_icon: Control = $HBoxContainer/EnergyBeamIcon
@onready var laser_icon: Control = $HBoxContainer/LaserIcon
@onready var pacifist_icon: Control = $HBoxContainer/PacifistIcon
@onready var shield_icon: Control = $HBoxContainer/ShieldIcon
@onready var toxic_icon: Control = $HBoxContainer/ToxicIcon

func update(ship: Ship, rad_data: Dictionary[Star3D.RaditionType, float]):
	var camera := get_viewport().get_camera_3d()
	global_position = camera.unproject_position(ship.global_position)
	global_position -= size*0.5 + Vector2.DOWN * 64.0
	
	for key in rad_data.keys():
		match key:
			Star3D.RaditionType.FUEL:
				energy_icon.visible = rad_data[key] > 0.0
			Star3D.RaditionType.SHILD:
				shield_icon.visible = rad_data[key] > 0.0
			Star3D.RaditionType.AMMO:
				laser_icon.visible = rad_data[key] > 0.0
			Star3D.RaditionType.PACE:
				pacifist_icon.visible = rad_data[key] > 0.0
			Star3D.RaditionType.TOKSIC:
				toxic_icon.visible = rad_data[key] > 0.0
			Star3D.RaditionType.FUEL_BEAM:
				energy_beam_icon.visible = rad_data[key] > 0.0
			Star3D.RaditionType.NONE:
				pass
