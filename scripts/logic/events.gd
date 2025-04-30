extends Node

#region Initialized Variables and Exports
# POV
enum POV_Character {
	ADI,
	WIKS,
	BOTH
}

signal change_map(path: String)
signal open_camera_signal()
signal pov_switch()
signal show_contextual_menus(value: bool)

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
	scrapbook_pictures = []
#endregion

#region Custom Functions
## Changes area to the PackedScene [param path].
## Pretty much a helper function for a signal to make code readable.
func change_area(path: String) -> void:
	change_map.emit(path)

## Set the current [param POV] of the game.
func set_current_pov(value: POV_Character) -> void:
	# Change values.
	print("Current POV: " + POV_Character.find_key(value))
	current_pov = value
	
	# Then emit signal to let all items now of the switch.
	pov_switch.emit()
	
## Get the current POV of the game.
func get_current_pov() -> POV_Character:
	return current_pov

## Helper function to show/hid contextual menus in game
func show_the_context_menus(value: bool) -> void:
	show_contextual_menus.emit(value)

## Get the name of the current character in the POV of the game.
func get_current_pov_name() -> String:
	return POV_Character.find_key(current_pov).capitalize()

## Helper function to make code easier to read.
func open_camera() -> void:
	open_camera_signal.emit()

## Resets everything when going back to main menu.
func reset()-> void:
	current_pov = POV_Character.ADI
	scrapbook_pictures = []
#endregion
