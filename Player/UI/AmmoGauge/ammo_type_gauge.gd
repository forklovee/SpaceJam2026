class_name AmmoTypeGauge extends Control

@onready var ammo_name: Label = $AmmoType
@onready var ammo_counter: Label = $HBoxContainer/Label

@export var icon: Texture

func update_amount(ship: Ship, ammo_type: Bullet3D.Type):
	ammo_name.text = Bullet3D.Type.keys()[ammo_type]
	ammo_counter.text = str(ship.get_ammo_count(ammo_type))+"/"+str(ship.get_max_ammo_count(ammo_type))
