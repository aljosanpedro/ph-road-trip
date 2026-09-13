@icon("res://nodes/command_outline.svg")

class_name ShowEventOutlineCommand
extends Commands

## Show switch to show item outline.
@export var switch: bool = true

func execute() -> bool:
	Events.show_item_outline(switch)
	return true
