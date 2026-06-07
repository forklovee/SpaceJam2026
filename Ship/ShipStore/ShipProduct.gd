extends Resource
class_name ShipProduct

@export var based_ship:ShipModel
var equipment:Array[ShipModelUpgrade]
var slots:Array[ShipModelUpgrade] #unused


func apllay(s:Ship):
	if true:
		var m=based_ship.BaseMass
		for u in equipment:
			m+=u.ExtraMass
		s.mass=m

	if true:
		var h=based_ship.BaseHealth
		for u in equipment:
			h+=u.ExtraHealth
		s.max_health=h
	
	if true:
		var h=based_ship.BaseHealth
		for u in equipment:
			h+=u.ExtraHealth
		s.max_health=h
	
	if true:
		var h=based_ship.BaseShield
		for u in equipment:
			h+=u.ExtraShield
		s.max_shield=h

	if true:
		var h=based_ship.BaseStorage
		for u in equipment:
			h+=u.ExtraStorage
		s.max_storage=h

func has_in_equipment(id):
	return equipment.find(based_ship.upgrades[id])!=-1
