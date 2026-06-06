class_name RadiationQuery extends Node3D

var data: Dictionary

func update() -> void:
	if !Game.level: return
	
	var sp: SpacePlane = Game.level.query_plane
	if !sp: return
	
	var a:PackedVector2Array=PackedVector2Array([])
	for id in range(get_child_count()):
		var c:Node3D=get_child(id)
		a.append(Vector2(c.global_position.x,c.global_position.z))
	
	data = sp.querry(a)
