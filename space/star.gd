@tool
extends MeshInstance3D

class_name Star3D

@export var color:Color
@export var rad:float
@export var freq_profile:Texture #Maybe if time

@export var rot:float=0.0
@export var pause:bool=true

func _process(delta: float) -> void:
	if not(pause and Engine.is_editor_hint()):
		self.rotate_y(delta*rot)
