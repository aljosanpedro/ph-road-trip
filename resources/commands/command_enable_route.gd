@icon("res://nodes/command_route.svg")

class_name EnableRouteCommand
extends Commands

## Route to enable
@export var route: Events.Locations

@warning_ignore("unused_parameter")
func execute(node: MapEventBase) -> bool:
	Events.enable_route(route)
	return true
