extends Node

#region Initialized Variables and Exports
# POV
enum POV_Character {
	ADI,
	WIKS,
	BOTH
}

# Locations
enum Locations {
	UPDQC,
	Cubao,
	Makati,
	Quiapo,
	Coast,
	Jabee
}

signal change_map(path: String)

# Item_Base
signal set_item_outline(value: bool)

# For Camera Scene
signal open_camera_signal()
signal camera_photo_taken()

# For Map Travel 
signal unlock_location(loc_name: Locations)
signal open_travel_map()

signal pov_switch()
signal show_contextual_menus(value: bool)
signal switch_has_been_set

var current_pov: POV_Character = POV_Character.WIKS

var switches: Dictionary[String, bool] = {
	# Location 1
	"loc_1_stall": false,
	"loc_1_sunken_garden": false,
	"loc_1_adis_mural": false,
	"loc_1_trees": false,
	"loc_1_loose_chicken": false,
	
	# Location 2
	"loc_2_kids_playing": false,
	"loc_2_lanterns": false,
	"loc_2_radio": false,
	"loc_2_graffiti": false,
	"loc_2_clothes": false,
	"loc_2_mannequins": false,
	"loc_2_jabee": false,
}


# Scrapbook
const SCRAPBOOK_ENTRIES : int = 7
var scrapbook_pictures : Array[Node] = []
#endregion

#region Virtual functions
func _ready() -> void:
	pass

## Initializes Events for a new game.
func initialize() -> void:
	for sw in switches:
		switches[sw] = false
	current_pov = POV_Character.ADI
	scrapbook_pictures = []
#endregion

#region Custom Functions
## Wait, literally.
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds, false, false, true).timeout

## Changes area to the PackedScene [param path].
## Pretty much a helper function for a signal to make code readable.
func change_area(path: String) -> void:
	change_map.emit(path)

func enable_route(loc_name: Locations) -> void:
	unlock_location.emit(loc_name)

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

# Sets [b]Events.switch[/b] [param name] to the following [param value]
# Also emits a switch set in case for anything that needs it.
func set_switch(switch_name: String, value: bool) -> void:
	switches[switch_name] = value
	switch_has_been_set.emit()

# Get the switch's value.
func get_switch(switch_name) -> bool:
	return switches[switch_name]

## Resets everything when going back to main menu.
func reset()-> void:
	for sw in switches:
		switches[sw] = false
		
	current_pov = POV_Character.ADI
	scrapbook_pictures = []

## Shows the item outline when needed.
func show_item_outline(value: bool) -> void:
	set_item_outline.emit(value)

## Shows the travel map scene.
func show_travel_map_scene() -> void:
	open_travel_map.emit()

## Default interaction when dealing with already interacted item.
func item_already_interacted() -> void:
	Dialogic.start("res://assets/dialogue/default_dialogue.dtl", "already_interacted")
	await Dialogic.timeline_ended

#endregion
