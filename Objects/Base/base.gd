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
				if Input.is_key_pressed(KEY_TAB):
					Game.pc.hud.show_repair_munu(self,b)
				var ship:Ship=b
				$MeshInstance3D/OmniLight3D.visible=true
				var c=ship.storage
				if c>0:
					print("transfer:",c)
				ship.storage=0
				ship.transfer_crystal()
				Game.player_score+=c
	else:
		$MeshInstance3D/OmniLight3D.visible=false
		#if !get_overlapping_bodies().is_empty():
		#	print(get_overlapping_bodies())
		for b in get_overlapping_bodies():
			if b.is_in_group("EnemyShip"):
				#print("##########333")
				var ship:Ship=b
				$MeshInstance3D/OmniLight3D.visible=true
				var c=ship.storage
				if c>0:
					print("Enemy transfer:",c)
				ship.storage=0
				ship.transfer_crystal()
				Game.enemy_score+=c
				#TMP
				if c>0:
					print("FAKE DIE")
					ship.damage(null,10000.0)#TODO 


#func _on_body_entered(body: Node3D) -> void:
#	if body.is_in_group("PlayerShip"):
#		var ship:Ship=body
