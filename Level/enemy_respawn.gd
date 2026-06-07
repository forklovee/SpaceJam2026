extends Node3D

class_name EnemyRespawn

enum EnemyType{None,Normal,Big}

var starting_wave=[EnemyType.Normal,EnemyType.Normal]
var middle_wave=[EnemyType.Normal,EnemyType.Big]
var final_wave=[EnemyType.Big,EnemyType.Big]

var to_spawn=0
var time=0.0
@export var CullDown=3.0

var id=0

var waves=[]
var wave_type=0
func _ready() -> void:
	waves.append(starting_wave)
	waves.append(middle_wave)
	waves.append(final_wave)

func _process(delta: float) -> void:
	if to_spawn>0:
		time+=delta
		if time>CullDown:
			print("RESPAWN")
			var current_wave:Array=waves[wave_type]
			if wave_type<2:
				if id==current_wave.size()-1:
					wave_type+=1
			to_spawn-=1
			time=0.0
			var p = global_position * Vector3(1.0, 0, 1.0)
			var a=randf()*2*PI
			p+=Vector3(sin(a),0.0,cos(a))*2.0
			var e=Data.enemies[current_wave[id]].instantiate()
			id=(id+1)%(current_wave.size())
			
			var level = Game.level
			level.add_child(e)
			e.global_position = p
