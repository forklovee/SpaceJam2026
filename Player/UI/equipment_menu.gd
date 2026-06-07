extends ColorRect

@export var currentShip:ShipProduct
@export var allYourShip:Array[ShipProduct]
@export var storeShip:Array[ShipProduct]


#func _ready() -> void:
#	hide()

func _process(delta: float) -> void:
	if self!=null:
		if visible:
			$Label.text="MONEY "+str(Game.gold)
			
			
			$Label3.text=currentShip.based_ship.BrandName
			$Label2.text=currentShip.based_ship.marketing_text
			$UPGRADES4/UPG1.text=currentShip.based_ship.upgrades[0].BrandName
			$UPGRADES4/UPG1/ColorRect.visible=currentShip.has_in_equipment(0)
			$UPGRADES4/UPG2.text=currentShip.based_ship.upgrades[1].BrandName
			$UPGRADES4/UPG2/ColorRect2.visible=currentShip.has_in_equipment(1)
			$UPGRADES4/UPG3.text=currentShip.based_ship.upgrades[2].BrandName
			$UPGRADES4/UPG3/ColorRect3.visible=currentShip.has_in_equipment(2)
			if Input.is_key_pressed(KEY_ESCAPE):
				self.visible=false
			var a=[
				$ColorRect3/SHIP1,
				$ColorRect3/SHIP2,
				$ColorRect3/SHIP3,
			]
			var all_ship=[]
			for s in allYourShip:
				all_ship.append(s)
			for s in storeShip:
				if all_ship.find(s)==-1:
					all_ship.append(s)
			for id in range(all_ship.size()):
				a[id].text=all_ship[id].based_ship.BrandName
				if id<allYourShip.size():
					a[id].get_child(0).visible=true
				else:
					a[id].text+=" buy "+str(all_ship[id].based_ship.price)
					a[id].get_child(0).visible=false
			#for s in storeShip:
				


func buy_up(id):
	if !currentShip.has_in_equipment(id):
		if currentShip.equipment.size()<currentShip.based_ship.upgrade_slots:
			currentShip.equipment.append(currentShip.based_ship.upgrades[id])
	else:
		currentShip.equipment.erase(currentShip.based_ship.upgrades[id])
		
	currentShip.apllay(Game.pc.ship)
	Game.pc.hud._on_storage_changed(Game.pc.ship)


func _on_laser_button_pressed() -> void:
	var w=Data.extra_wepons[1]
	equip(w)


func _on_rocket_button_pressed() -> void:
	var w=Data.extra_wepons[0]
	equip(w)
	
func equip(w:PackedScene):
	var gun:Gun=w.instantiate()
	var s:Ship=Game.pc.ship
	var slot=s.get_node("WingL_GunSlot")
	if is_instance_valid(slot):
		var lw=slot.get_child(0)
		lw.reparent(Game.level)
		lw.queue_free()
		
		slot.add_child(gun)
		gun.global_position=slot.global_position
		s.update_weapons_and_gunslots()
					


func buy_ship(id):
	var all_ship=[]
	for s in allYourShip:
		all_ship.append(s)
	for s in storeShip:
		if all_ship.find(s)==-1:
			all_ship.append(s)
	if allYourShip.find(all_ship[id])!=-1:
		currentShip=allYourShip[id]
		currentShip.apllay(Game.pc.ship)
		Game.pc.hud._on_storage_changed(Game.pc.ship)
	else:
		if Game.gold>all_ship[id].based_ship.price:
			Game.gold-=all_ship[id].based_ship.price
			allYourShip.append(all_ship[id])


func _on_upg_1_pressed() -> void:
	buy_up(0)


func _on_upg_2_pressed() -> void:
	buy_up(1)


func _on_upg_3_pressed() -> void:
	buy_ship(0)
	
	
	


func _on_ship_1_pressed() -> void:
	buy_ship(0)


func _on_ship_2_pressed() -> void:
	buy_ship(1)


func _on_ship_3_pressed() -> void:
	buy_ship(2)
