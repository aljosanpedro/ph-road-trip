@icon("res://nodes/command_outline.svg")

class_name ShowEventOutlineCommand
extends Commands

## Show switch to show item outline.
@export var switch: bool = true

@warning_ignore("unused_parameter")
func execute(node: MapEventBase) -> bool:
	Events.show_item_outline(switch)
	return true
