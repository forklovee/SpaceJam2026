extends Area3D
class_name Bullet3D


var velocity:Vector3
var is_allay=false


func _process(delta: float) -> void:
	self.global_position+=velocity*delta
