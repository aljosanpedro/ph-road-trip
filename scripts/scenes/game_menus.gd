extends CanvasLayer

@onready var scene_map_travel = $MapTravel

## Opens map travel.
func open_map_travel() -> void:
	scene_map_travel.visible = true
	
