extends Area3D

@export var is_allay=false


func _process(delta: float) -> void:
	if is_allay:
		$MeshInstance3D/OmniLight3D.visible=false
		for b in get_overlapping_bodies():
			if b.is_in_group("PlayerShip"):
				var ship:Ship=b
				$MeshInstance3D/OmniLight3D.visible=true
				var c=ship.storage
				if c>0:
					print("transfer:",c)
				ship.storage=0
				Game.player_score+=c


#func _on_body_entered(body: Node3D) -> void:
#	if body.is_in_group("PlayerShip"):
#		var ship:Ship=body
		
