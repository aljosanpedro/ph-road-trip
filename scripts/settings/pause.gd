extends Control


@onready var screen : Node = $Screen


func _on_button_toggled(toggled_on: bool) -> void:
	get_tree().paused = toggled_on
	screen.visible = toggled_on
