@icon("res://nodes/command_route.svg")

class_name EnableRouteCommand
extends Commands

## Route to enable
@export var route: Events.Locations

func execute() -> bool:
	Events.enable_route(route)
	return true
