extends TextureButton

@export var location: PackedScene

func _ready() -> void:
	# enable_button(false)
	pass
	
func _on_pressed() -> void:
	Events.change_area(location.resource_path)

## Enables or disables button based on [param value].
func enable_button(value: bool) -> void:
	disabled = not value
	if value: set_self_modulate(Color(1,1,1))
	else: set_self_modulate(Color(1.5,1,1))
