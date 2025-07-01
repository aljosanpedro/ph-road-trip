@icon("res://nodes/location_button.svg")

class_name MapButton
extends TextureButton

@export var location: PackedScene

func _ready() -> void:
	# enable_button(false)
	pass
	
## Enables or disables button based on [param value].
func enable_button(value: bool) -> void:
	disabled = not value
	if value: set_self_modulate(Color(0,1,0))
	else: set_self_modulate(Color(1,0,0))
