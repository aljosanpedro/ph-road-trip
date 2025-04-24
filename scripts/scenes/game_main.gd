extends Node


#region Initialized Variables and Exports
## INFO: Enums
enum CurrentGameScene {
	CURRENT_MAP,
	MAP_TRAVEL,
	PAUSE_MENU
}
#enum POV_Character {
	#ADI,
	#WIKS
#}

## INFO: Exported variables
@export var current_scene: PackedScene

## INFO: Onready variables
@onready var game_area = $GameArea
@onready var context_menu_layer = $ContextMenus
@onready var scene_camera = $ContextMenus/Camera
@onready var scene_map_travel = $ContextMenus/MapTravel

## INFO: Other variables
## Sets Adi as the default POV character.
var current_game_scene = CurrentGameScene.CURRENT_MAP
#endregion

#region Virtual functions
func _ready() -> void:
	# INFO: Initialize Events singleton for a new game.
	Events.initialize()
	
	scene_map_travel.visible = false
	
	# INFO: Initialize connections to the Events scene.
	Events.change_map.connect(_goto_area)
	Events.show_contextual_menus.connect(_show_game_contextual_menus)
	
	# INFO: Start game. Kinda funny we're doing loop-de-loops here.
	Events.change_area(current_scene.resource_path)
	Events.show_the_context_menus(false) # By default, as intro will flick it up.
	
#endregion

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("open_map"):
		_map_travel_scene_call()
		get_viewport().set_input_as_handled()
		
	if event.is_action_pressed("open_scrapbook"):
		get_tree().change_scene_to_file("res://scenes/scenes/scrapbook.tscn")
		get_viewport().set_input_as_handled()

#region Area Change Functions
## First is path.
func _goto_area(path: String) -> void:
	if ResourceLoader.exists(path):
		call_deferred("_deferred_change_area", path)
	
## Changes scene. Deferred JUST IN CASE.
func _deferred_change_area(path: String) -> void:
	# bc global @export var current_scene at top of file
	# unless want to rename ofc xD
	@warning_ignore("shadowed_variable")
	
	var current_scene = get_node("GameArea")
	var new_scene = ResourceLoader.load(path)
	
	current_scene.free()
	current_scene = new_scene.instantiate()
	
	add_child(current_scene)
	current_scene.name = "GameArea"
	move_child(current_scene, 0)
#endregion

#region Custom function
## Call the map travel scene.
func _map_travel_scene_call() -> void:
	if current_game_scene != CurrentGameScene.MAP_TRAVEL:
		current_game_scene = CurrentGameScene.MAP_TRAVEL
		scene_map_travel.visible = true
		return
		
	elif current_game_scene == CurrentGameScene.MAP_TRAVEL:
		current_game_scene = CurrentGameScene.CURRENT_MAP
		scene_map_travel.visible = false
		return

## Is called when the map travel scene is closed via the MapTravel signal.
func _on_scene_map_travel_closed() -> void:
	_map_travel_scene_call()

func _show_game_contextual_menus(value: bool) -> void:
	context_menu_layer.visible = value
#endregion

#func _on_settings_opened() -> void:
	#$Settings/Pause._on_button_toggled(true)
