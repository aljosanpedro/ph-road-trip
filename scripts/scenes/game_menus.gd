extends CanvasLayer

@onready var scene_map_travel = $MapTravel

## Opens map travel.
func open_map_travel() -> void:
	Events.current_scene_context = Events.SCENE_CONTEXT.IN_MENU
	scene_map_travel.visible = true
	
