@icon("res://nodes/command_context_menu.svg")

class_name ShowContextMenuCommand
extends Commands

## Show switch to show item outline.
@export var switch: bool = true

func execute(node: MapEventBase) -> bool:
	Events.show_the_context_menus(switch) # By default, as intro will flick it up.
	return true
