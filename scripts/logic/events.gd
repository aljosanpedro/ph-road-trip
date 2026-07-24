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

# Scene context
enum SCENE_CONTEXT {
	IN_GAME,
	IN_MENU
}

signal change_map(path: String)
signal area_change_completed

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
signal toggle_pause_menu(value: bool)
signal toggle_pause_menu_layer(value: bool)
signal switch_has_been_set

# For save/load shortcuts
signal shortcut_save_pressed
signal shortcut_load_pressed

# For opening save/load menu
signal open_save_menu
signal open_load_menu

# For menus opening/closing
#signal any_menu_opened_closed(node: Control)

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

## Exposing game main instead because this architecture BLOWS.
var game_main: MainGameFrame

## Exposing save/load menu for shortcut access.
var save_load_menu: SaveLoadMenu

## Tracks the currently loaded location scene path for save/load.
var current_scene_path: String = ""

## Flag to skip scene _ready() logic during save load.
var is_restoring_timeline: bool = false

## Tracks which location intros have already been played.
var intros_played: Dictionary = {}

## Tracks a pending interactable switch to set when its dialogue ends.
## Used for save/load: if set, a one-time timeline_ended handler will finish it.
var pending_interactable_switch: String = ""

## Current Scene Context.
var current_scene_context: SCENE_CONTEXT = SCENE_CONTEXT.IN_MENU:
	get:
		return current_scene_context
	set(value):
		print("Current scene context: ", SCENE_CONTEXT.keys()[value])
		current_scene_context = value

	# INFO: Set via open_camera(), any_menu_opened(), pause_menu.gd, game_main.gd, camera.gd, history_layer.gd

#endregion
func _init() -> void:
	Dialogic.timeline_started.connect(_events_when_timeline_started)
	Dialogic.timeline_ended.connect(_events_when_timeline_ended)

#region Virtual functions
func _ready() -> void:
	false

# For more global handling
func _unhandled_key_input(event: InputEvent) -> void:
	# Handle fullscreen toggling.
	if Input.is_action_just_pressed("shortcut_fullscreen"):
		_fullscreen_shortcut_pressed()
		get_viewport().set_input_as_handled()
	
	if Input.is_action_just_pressed("show_menu") and current_scene_context != SCENE_CONTEXT.IN_MENU:
		show_pause_menu(true)
		get_viewport().set_input_as_handled()
	
	if Input.is_action_just_pressed("shortcut_save") and current_scene_context == SCENE_CONTEXT.IN_GAME:
		shortcut_save_pressed.emit()
		get_viewport().set_input_as_handled()
	
	if Input.is_action_just_pressed("shortcut_load") and current_scene_context == SCENE_CONTEXT.IN_GAME:
		shortcut_load_pressed.emit()
		get_viewport().set_input_as_handled()
		
## Initializes Events for a new game.
func initialize() -> void:
	current_scene_context = SCENE_CONTEXT.IN_GAME
	current_scene_path = ""
	is_restoring_timeline = false
	intros_played = {}
	pending_interactable_switch = ""
	for sw in switches:
		switches[sw] = false
	current_pov = POV_Character.ADI
	scrapbook_pictures = []
#endregion

#region Dialogic-targeting Functions
## Function that will intercept timeline_started events to do stuff.
func _events_when_timeline_started() -> void:
	toggle_pause_menu_layer.emit(false)

## Function that will intercept timeline_ended events to do stuff.
func _events_when_timeline_ended() -> void:
	toggle_pause_menu_layer.emit(true)

## Helper function to force Dialogic to open history :D
func show_history(value: bool) -> void:
	if value: DialogicUtil.autoload().History.open_history()
	else: DialogicUtil.autoload().History.close_history()

## Finishes an interactable after its dialogue ends.
func finish_interactable(switch_name: String) -> void:
	show_item_outline(true)
	set_switch(switch_name, true)
	pending_interactable_switch = ""

#endregion

#region Custom Functions
## Wait, literally.
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds, false, false, true).timeout

## Changes area to the PackedScene [param path].
## Pretty much a helper function for a signal to make code readable.
func change_area(path: String) -> void:
	current_scene_path = path
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

## Helper function to show/hide contextual menus in game
func show_the_context_menus(value: bool) -> void:
	show_contextual_menus.emit(value)

## Helper function to show/hide pause menu in game.
func show_pause_menu(value: bool) -> void:
	toggle_pause_menu.emit(value)

## Helper function to show save menu.
func show_save_menu() -> void:
	open_save_menu.emit()

## Helper function to show load menu.
func show_load_menu() -> void:
	open_load_menu.emit()

## Helper function to show/hide the button of the pause menu in game.
func show_pause_menu_button(value: bool) -> void:
	toggle_pause_menu_layer.emit(value)

## Get the name of the current character in the POV of the game.
func get_current_pov_name() -> String:
	return POV_Character.find_key(current_pov).capitalize()

## Helper function to make code easier to read.
func open_camera() -> void:
	current_scene_context = SCENE_CONTEXT.IN_MENU
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
	current_scene_path = ""
	is_restoring_timeline = false
	intros_played = {}
	pending_interactable_switch = ""
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

## Universal helper function to check if there's any changes for menus elsewhere.
func any_menu_opened(node: Control) -> void:
	if node.visible: 
		DialogicUtil.autoload().Inputs.auto_skip.enabled = false
		DialogicUtil.autoload().Inputs.auto_advance.enabled_until_user_input = false
		
		# Least breaking idea:
		# Remove actual player agency when in a menu.
		Dialogic.Inputs.manual_advance.system_enabled = false
		
		current_scene_context = SCENE_CONTEXT.IN_MENU
	else:
		Dialogic.Inputs.manual_advance.system_enabled = true
		current_scene_context = SCENE_CONTEXT.IN_GAME
#endregion

#region Custom Shortcut Handling
func _fullscreen_shortcut_pressed() -> void:
	match DisplayServer.window_get_mode():
		DisplayServer.WINDOW_MODE_FULLSCREEN:
			GameSettings.fullscreen_change(false)
		_:
			GameSettings.fullscreen_change(true)
#endregion
