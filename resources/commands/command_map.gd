@icon("res://nodes/command_map.svg")

class_name OpenMapCommand
extends Commands

func execute() -> bool:
	Events.show_travel_map_scene()
	return true
