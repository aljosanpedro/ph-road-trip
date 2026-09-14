@icon("res://nodes/command_map.svg")

class_name OpenMapCommand
extends Commands

@warning_ignore("unused_parameter")
func execute(node: MapEventBase) -> bool:
	Events.show_travel_map_scene()
	return true
