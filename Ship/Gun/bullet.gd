extends Area3D
class_name Bullet3D


var velocity:Vector3
var shot_by=null


func _process(delta: float) -> void:
	assert(shot_by!=null)
	self.global_position+=velocity*delta


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Crystal"):
		var c:Cristal=body
		c.hit(1,shot_by)
