extends Node

#region Initialized Variables and Exports
# POV
enum POV_Character {
	ADI,
	WIKS
}
signal change_map(path: String)
signal open_camera_signal()
signal enable_character_povs(value: bool)

var current_pov: POV_Character = POV_Character.ADI

# Scrapbook
const SCRAPBOOK_ENTRIES : int = 7
var scrapbook_pictures : Array[Node] = []
#endregion

#region Virtual functions
func _ready() -> void:
	pass

## Initializes Events for a new game.
func initialize() -> void:
	current_pov = POV_Character.ADI
#endregion

#region Custom Functions
## Changes area to the PackedScene [param path].
## Pretty much a helper function for a signal to make code readable.
func change_area(path: String) -> void:
	change_map.emit(path)

## Helper function to make code easier to read.
func open_camera() -> void:
	open_camera_signal.emit()

#region POV Switch Functions
#===================================================================
# POV Switch Functions
#===================================================================
## Set the current [param POV] of the game.
func set_current_pov(value: POV_Character) -> void:
	print("Current POV: " + POV_Character.find_key(value))
	current_pov = value

## Get the current POV of the game.
func get_current_pov() -> POV_Character:
	return current_pov

## Helper function to enable/disable [param value] for POV switching.
func scene_pov_enable(value: bool) -> void:
	enable_character_povs.emit(value)
	
#endregion

#endregion
