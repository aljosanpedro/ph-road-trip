@icon("res://nodes/command_pov_switch.svg")

class_name POVSwitchCommand
extends Commands

## Character to swap to
@export var character: Events.POV_Character

@warning_ignore("unused_parameter")
func execute(node: MapEventBase) -> bool:
	Events.set_current_pov(character)
	return true
