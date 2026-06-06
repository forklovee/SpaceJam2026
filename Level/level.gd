class_name Level extends Node3D

signal crystal_amount_changed(level: Level)

var crystals_to_gather: Array = []

func _ready() -> void:
	crystals_to_gather = get_tree().get_nodes_in_group(&"Crystal")
	for crystal in crystals_to_gather:
		crystal = crystal as Crystal
		crystal.gathered.connect(_on_crystal_gathered.bind(crystal))
	
	print(self, " registered ", crystals_to_gather.size(), " crystals.")

func _on_crystal_gathered(_ship, crystal: Crystal):
	if crystal in crystals_to_gather:
		crystals_to_gather.erase(crystal)
		crystal_amount_changed.emit(self)
