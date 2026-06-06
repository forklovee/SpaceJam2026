extends Label

func _process(delta: float) -> void:
	$".".text="Score:"+str(Game.player_score)
