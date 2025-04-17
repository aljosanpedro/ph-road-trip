extends Node

#region Initialized Variables and Exports
enum POV_Character {
	ADI,
	WIKS
}
signal change_map(path: String)

var current_pov: POV_Character = POV_Character.ADI
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

## Set the current [param POV] of the game.
func set_current_pov(value: POV_Character) -> void:
	print("Current POV: " + POV_Character.find_key(value))
	current_pov = value

## Get the current POV of the game.
func get_current_pov() -> POV_Character:
	return current_pov
#endregion
