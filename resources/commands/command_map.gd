@icon("res://nodes/command_map.svg")

class_name OpenMapCommand
extends Commands

func execute(node: MapEventBase) -> bool:
	Events.show_travel_map_scene()
	return true
