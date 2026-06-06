class_name Crystal extends StaticBody3D

signal gathered(ship: Ship)

func destroy(ship: Ship):
	gathered.emit(ship)
