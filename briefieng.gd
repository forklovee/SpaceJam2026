class_name BriefingScreen extends Control

signal briefing_end

@onready var narration: AudioStreamPlayer2D = $NarracjaBriefieng

func _ready() -> void:
	show()
	modulate = Color(1.0, 1.0, 1.0, 1.0)
	narration.finished.connect(_on_narration_finished)

func _on_narration_finished():
	var tween := get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(), 0.5)
	await tween.finished
	await get_tree().create_timer(0.1).timeout
	briefing_end.emit()
	hide()
