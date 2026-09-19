@icon("res://nodes/command_template.svg")

class_name ToggleMouseCommand
extends Commands

## If true, show mouse. If false, hide mouse.
@export var toggle_mouse_mode: bool = false

@warning_ignore("unused_parameter")
func execute(node: MapEventBase) -> bool:
	if toggle_mouse_mode: Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else: Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	return true
