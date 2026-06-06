@tool
extends MeshInstance3D

@export var input_stars:Array[Star3D]

func _process(delta: float) -> void:
	var m:ShaderMaterial=get_surface_override_material(0)
	var stars=PackedVector2Array([])
	var stars_color=PackedVector3Array([])
	stars.resize(12)
	stars_color.resize(12)
	for id in range(input_stars.size()):
		stars[id]=Vector2(input_stars[id].global_position.x,input_stars[id].global_position.z)
		stars_color[id]=Vector3(input_stars[id].color.r,input_stars[id].color.g,input_stars[id].color.b)
	
	m.set_shader_parameter("stars",stars)
	m.set_shader_parameter("stars_color",stars_color)
