extends Node3D

var bg=null


func _process(delta: float) -> void:
	if bg==null:
		bg = Game.level.get_node("Space_BG")
	if bg!=null:
		var a:PackedVector2Array=PackedVector2Array([])
		for id in range(get_child_count()):
			var c:Node3D=get_child(id)
			a.append(Vector2(c.global_position.x,c.global_position.z))
		var rad=bg.querry(a)
		if get_parent().is_allay:
			Game.RAD_FUEL=rad[Star3D.RaditionType.FUEL]
			Game.RAD_SHILD=rad[Star3D.RaditionType.SHILD]
			Game.RAD_AMMO=rad[Star3D.RaditionType.AMMO]
			Game.RAD_PACE=rad[Star3D.RaditionType.PACE]
			Game.RAD_TOKSIC=rad[Star3D.RaditionType.TOKSIC]
			Game.RAD_FUEL_BEAM=rad[Star3D.RaditionType.FUEL_BEAM]
