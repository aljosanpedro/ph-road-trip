extends Node
#region Initialized Variables and Exports
## INFO: Exported variables
@export var current_scene: PackedScene 

## INFO: Onready variables
@onready var game_area = $GameArea
#endregion

#region Virtual functions
func _ready() -> void:
	# INFO: Initialize connections to the Events scene.
	Events.change_map.connect(_goto_area)
	
	# INFO: Start game. Kinda funny we're doing loop-de-loops here.
	Events.change_area(current_scene.resource_path)
#endregion

#region Area Change Functions
## First is path.
func _goto_area(path: String, can_blink: bool = true, special: bool = false):
	if ResourceLoader.exists(path):
		call_deferred("_deferred_change_area", path)
	
## Changes scene. Deferred JUST IN CASE.
func _deferred_change_area(path: String):
	var current_scene = get_node("GameArea")
	var new_scene = ResourceLoader.load(path)
	
	current_scene.free()
	current_scene = new_scene.instantiate()
	
	add_child(current_scene)
	current_scene.name = "GameArea"
	move_child(current_scene, 0)
#endregion
