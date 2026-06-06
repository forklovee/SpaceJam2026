@tool
extends MeshInstance3D

class_name Star3D

enum RaditionType{
		FUEL,
		SHILD,
		AMMO,
		PACE,
		TOKSIC,
		FUEL_BEAM,
		NONE,
		}

@export var color:Color
@export var flag:RaditionType
@export var rad:float
@export var anim:bool
@export var freq_profile:Texture #Maybe if time

@export var rot:float=0.0
@export var pause:bool=true
@export var neg:bool=false

func _process(delta: float) -> void:
	if not(pause and Engine.is_editor_hint()):
		self.rotate_y(delta*rot)
