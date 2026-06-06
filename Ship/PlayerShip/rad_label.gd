extends Label

func update(data: Dictionary[Star3D.RaditionType, float]) -> void:
	text=""
	
	text+="RAD_FUEL="+str(data[Star3D.RaditionType.FUEL])+"\n"
	text+="RAD_SHILD="+str(data[Star3D.RaditionType.SHILD])+"\n"
	text+="RAD_AMMO="+str(data[Star3D.RaditionType.AMMO])+"\n"
	text+="RAD_PACE="+str(data[Star3D.RaditionType.PACE])+"\n"
	text+="RAD_TOKSIC="+str(data[Star3D.RaditionType.TOKSIC])+"\n"
	text+="RAD_FUEL_BEAM="+str(data[Star3D.RaditionType.FUEL_BEAM])+"\n"
