@icon("res://nodes/command_scene_change.svg")

class_name SceneChangeCommand
extends Commands

## Destination of the scene change.
@export var destination: PackedScene

func execute(node: MapEventBase) -> bool:
	Events.change_area(destination.resource_path)
	return true
