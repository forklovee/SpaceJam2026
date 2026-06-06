extends Label

func _process(delta: float) -> void:
	text=""
	text+="var RAD_FUEL="+str(Game.RAD_FUEL)+"\n"
	text+="var RAD_SHILD="+str(Game.RAD_SHILD)+"\n"
	text+="var RAD_AMMO="+str(Game.RAD_AMMO)+"\n"
	text+="var RAD_PACE="+str(Game.RAD_PACE)+"\n"
	text+="var RAD_TOKSIC="+str(Game.RAD_TOKSIC)+"\n"
	text+="var RAD_FUEL_BEAM="+str(Game.RAD_FUEL_BEAM)+"\n"
