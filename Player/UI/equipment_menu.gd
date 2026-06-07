extends ColorRect

func _process(delta: float) -> void:
	if visible:
		if Input.is_key_pressed(KEY_ESCAPE):
			self.visible=false


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
		
		#Speed 15.0 cargo 10
		


func _on_l_button_pressed() -> void:
	var s:Ship=Game.pc.ship
	s.speed=15.0
	s.max_storage=10
	s.mass=1.0

func _on_h_button_pressed() -> void:
	var s:Ship=Game.pc.ship
	s.speed=0.0
	s.mass=3.0
	s.max_storage=20
