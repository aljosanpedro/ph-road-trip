extends Control


# CanvasLayers
	# Screen (2) > "Gameplay" (1)
	# Button (3) > Screen (2)


@onready var screen : Node = $Screen


func _on_button_toggled(toggled_on: bool) -> void:
	get_tree().paused = toggled_on
	screen.visible = toggled_on
