extends Node3D

var time=0.0
var cull_down=3.0

func _process(delta: float) -> void:
	if !is_instance_valid(Game.pc.ship):
		e_process(delta)
	#if Game.pc==null:
	#	e_process(delta)
func e_process(delta: float) -> void:
		#print("AAAA")
		time+=delta
		if time>cull_down:
			time=0.0
			
			var pl=Data.player_to_respawn.instantiate()
			var p=self.global_position
			var a=randf()*2*PI
			p+=Vector3(sin(a),0.0,cos(a))*2.0
			Game.level.add_child(pl)
			pl.global_position=p
			Game.pc.ship=pl
			Game.pc.camera.follow_target=pl
			Game.pc.hud.bind_ship(pl)
