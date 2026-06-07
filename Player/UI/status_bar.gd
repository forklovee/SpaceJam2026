class_name StatusBar extends Control

@onready var health: TextureProgressBar = $Health
@onready var shield: TextureProgressBar = $Shield
@onready var fuel: TextureProgressBar = $Energy
@onready var fuel_label: Label = $Energy/EnergyPercent

func bind(ship: Ship):
	ship.health_changed.connect(_on_health_updated)
	ship.got_damage.connect(_on_got_damaged)
	ship.shield_changed.connect(_on_shield_changed)
	ship.fuel_changed.connect(_on_fuel_changed)
	
	_on_health_updated(ship)
	_on_shield_changed(ship)
	_on_fuel_changed(ship)

func unbind(ship: Ship):
	ship.health_changed.disconnect(_on_health_updated)
	ship.got_damage.disconnect(_on_got_damaged)
	ship.shield_changed.disconnect(_on_shield_changed)
	ship.fuel_changed.disconnect(_on_fuel_changed)

func _on_health_updated(ship: Ship):
	health.value = ship.health
	health.max_value = ship.max_health

func _on_got_damaged(ship: Ship, _instigator: Ship):
	pass

func _on_shield_changed(ship: Ship):
	shield.value = ship.shield
	shield.max_value = ship.max_shield
	
func _on_fuel_changed(ship: Ship):
	fuel.value = clamp(ship.fuel, 0, ship.max_fuel)
	fuel.max_value = ship.max_fuel
	fuel_label.text = str(int(ship.fuel/ship.max_fuel * 100.0))+" %"
