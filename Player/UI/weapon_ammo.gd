class_name WeaponAmmo extends Control

@onready var regular_ammo: AmmoTypeGauge = $VBoxContainer/GridContainer/RegularAmmo
@onready var plsl_ammo: AmmoTypeGauge = $VBoxContainer/GridContainer/PLSLAmmo
@onready var rocket_ammo: AmmoTypeGauge = $VBoxContainer/GridContainer/RocketAmmo

func bind(ship: Ship):
	ship.used_weapon.connect(_on_ship_weapon_used)
	
	regular_ammo.hide()
	plsl_ammo.hide()
	rocket_ammo.hide()
	for weapon in ship.weapons:
		match weapon.bullet_type:
			Bullet3D.Type.Regular:
				regular_ammo.update_amount(ship, weapon.bullet_type)
				regular_ammo.show()
			Bullet3D.Type.PLSL:
				plsl_ammo.update_amount(ship, weapon.bullet_type)
				plsl_ammo.show()
			Bullet3D.Type.Rocket:
				rocket_ammo.update_amount(ship, weapon.bullet_type)
				rocket_ammo.show()

func unbind(ship: Ship):
	ship.used_weapon.disconnect(_on_ship_weapon_used)


func _on_ship_weapon_used(ship: Ship, bullet_type: Bullet3D.Type):
	match bullet_type:
		Bullet3D.Type.Regular:
			regular_ammo.update_amount(ship, bullet_type)
		Bullet3D.Type.PLSL:
			plsl_ammo.update_amount(ship, bullet_type)
		Bullet3D.Type.Rocket:
			rocket_ammo.update_amount(ship, bullet_type)
