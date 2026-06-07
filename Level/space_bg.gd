@tool
class_name SpacePlane extends MeshInstance3D

@export var input_stars:Array[Node]

func _ready() -> void:
	input_stars=get_tree().get_nodes_in_group("Star")

func _process(_delta: float) -> void:
	var m:ShaderMaterial=get_surface_override_material(0)
	var stars=PackedVector2Array([])
	var stars_color=PackedVector3Array([])
	var stars_Ani=PackedInt32Array([])
	stars.resize(40)
	stars_color.resize(40)
	stars_Ani.resize(40)
	for id in range(input_stars.size()):
		stars[id]=Vector2(input_stars[id].global_position.x,input_stars[id].global_position.z)
		stars_color[id]=Vector3(input_stars[id].color.r,input_stars[id].color.g,input_stars[id].color.b)
		if input_stars[id].neg:
			stars_color[id]*=-1.0
		stars_Ani[id]=1 if input_stars[id].anim else 0
	m.set_shader_parameter("stars",stars)
	m.set_shader_parameter("stars_color",stars_color)
	m.set_shader_parameter("stars_ani",stars_Ani)
	
func querry(poss) -> Dictionary[Star3D.RaditionType, float]:
	var di: Dictionary[Star3D.RaditionType, float] = {}
	di[Star3D.RaditionType.FUEL]=0.0
	di[Star3D.RaditionType.SHILD]=0.0
	di[Star3D.RaditionType.AMMO]=0.0
	di[Star3D.RaditionType.PACE]=0.0
	di[Star3D.RaditionType.TOKSIC]=0.0
	di[Star3D.RaditionType.FUEL_BEAM]=0.0
	di[Star3D.RaditionType.NONE]=0.0
	for id in range(input_stars.size()):
		var t=input_stars[id].flag
		if t!=Star3D.RaditionType.NONE:
			var p:Vector2=Vector2(input_stars[id].global_position.x,input_stars[id].global_position.z)
			var value=0.0
			for pos in poss:
				var dist=p.distance_to(pos) 
				if dist<3.0:
					value+=(3.0-dist)/3.0;
			di[t]+=value
	return di

func querry_f(pos:Vector2) -> Vector2:
	var cs=Vector2.INF
	var best_dist=1000000.0
	for id in range(input_stars.size()):
		var p:Vector2=Vector2(input_stars[id].global_position.x,input_stars[id].global_position.z)
		var dist=p.distance_to(pos) 
		if dist<best_dist:
			best_dist=dist
			cs=p
	if pos.distance_to(cs)>8.0:
		return (cs-pos)-8.0*(cs-pos).normalized()
	return Vector2.ZERO
