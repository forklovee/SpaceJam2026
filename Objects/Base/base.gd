class_name Base extends Area3D

@onready var spawnpoint: Marker3D = $Spawnpoint

@export var is_allay=false

func _ready() -> void:
	spawnpoint.global_position.y = 0.0
	if is_allay:
		$allay_gfx.visible=true
		$enemy_gfx.visible=false
	else:
		$allay_gfx.visible=false
		$enemy_gfx.visible=true

func _process(_delta: float) -> void:
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
				ship.transfer_crystal()
				Game.player_score+=c


#func _on_body_entered(body: Node3D) -> void:
#	if body.is_in_group("PlayerShip"):
#		var ship:Ship=body
