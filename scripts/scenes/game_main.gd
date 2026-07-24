@icon("res://nodes/game_main.svg")

class_name MainGameFrame
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
@export var initial_character_pov: Events.POV_Character = Events.POV_Character.WIKS

## INFO: Onready variables
@onready var game_area = $GameArea
@onready var context_menu_layer = $ContextMenus
@onready var scene_camera = $ContextMenus/Camera
@onready var scene_map_travel = $ContextMenus/MapTravel
@onready var pov_switch_graphic = $ContextMenus/POVSwitch
@onready var pause_menu: PauseMenu = $PauseMenus/PauseMenu
@onready var save_load_menu: SaveLoadMenu = $PauseMenus/SaveLoadMenu


## INFO: Other variables
## Sets Adi as the default POV character.
var current_game_scene = CurrentGameScene.CURRENT_MAP

#endregion

#region Virtual functions
func _ready() -> void:
	
	# INFO: Tell events that you are the GameMainFrame.
	Events.game_main = self
	
	# INFO: Expose save/load menu to Events for shortcut access.
	Events.save_load_menu = save_load_menu
	
	# INFO: ???????????? What the sigma?
	scene_map_travel.visible = false
	
	# INFO: Initialize connections to the Events scene.
	Events.change_map.connect(_goto_area)
	Events.show_contextual_menus.connect(_show_game_contextual_menus)
	Events.open_travel_map.connect(_map_travel_scene_call)
	Events.open_save_menu.connect(_on_open_save_menu)
	Events.open_load_menu.connect(_on_open_load_menu)
	
	# INFO: Check if we're loading a saved game from title screen.
	if Engine.has_meta("pending_load_slot"):
		var slot_name = Engine.get_meta("pending_load_slot")
		var game_state = Engine.get_meta("pending_game_state")
		Engine.remove_meta("pending_load_slot")
		Engine.remove_meta("pending_game_state")
		
		Events.is_restoring_timeline = true
		await save_load_menu._restore_game_state(slot_name, game_state)
		Events.is_restoring_timeline = false
		Dialogic.Save.load(slot_name)
		save_load_menu._finish_pending_interactable()
		Dialogic.Inputs.manual_advance.system_enabled = true
		Events.current_scene_context = Events.SCENE_CONTEXT.IN_GAME
	else:
		# INFO: Initialize Events singleton for a new game.
		Events.initialize()
		
		# INFO: Start game. Kinda funny we're doing loop-de-loops here.
		Events.change_area(current_scene.resource_path)
		Events.show_the_context_menus(false) # By default, as intro will flick it up.
		Events.set_current_pov(initial_character_pov)
	
#endregion

func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("open_map"):
		#_map_travel_scene_call()
		#get_viewport().set_input_as_handled()
		
	#if event.is_action_pressed("open_scrapbook"):
		#get_tree().change_scene_to_file("res://scenes/scenes/scrapbook.tscn")
	
	pass

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
	
	await _fade_out_from_scene(current_scene)
	
	current_scene.free()
	current_scene = new_scene.instantiate()
	
	# Add child...
	add_child(current_scene)
	
	# Before naming it...!
	current_scene.name = "GameArea"
	current_scene.modulate = Color.BLACK
	
	# New scene must always be the first.
	move_child(current_scene, 0)
	
	_fade_in_to_scene(current_scene)
	Events.area_change_completed.emit()
	
#endregion

#region Custom function

func _fade_out_from_scene(game_area: Node2D) -> void:
	# Make tween for fade out
	var tween = create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(pov_switch_graphic, "position", Vector2(416,-72), 0.1)
	tween.tween_property(game_area, "modulate", Color.BLACK, 0.5)
	await tween.finished

func _fade_in_to_scene(game_area: Node2D) -> void:
		# Then fade in again.
	var new_tween = create_tween().set_parallel(true)
	new_tween.set_ease(Tween.EASE_IN_OUT)
	new_tween.tween_property(pov_switch_graphic, "position", Vector2(416,0), 0.1)
	new_tween.tween_property(game_area, "modulate", Color.WHITE, 0.5)
	await new_tween.finished

## Call the map travel scene.
func _map_travel_scene_call() -> void:
	if current_game_scene != CurrentGameScene.MAP_TRAVEL:
		current_game_scene = CurrentGameScene.MAP_TRAVEL
		Events.current_scene_context = Events.SCENE_CONTEXT.IN_MENU
		scene_map_travel.visible = true
		return
		
	elif current_game_scene == CurrentGameScene.MAP_TRAVEL:
		current_game_scene = CurrentGameScene.CURRENT_MAP
		Events.current_scene_context = Events.SCENE_CONTEXT.IN_GAME
		scene_map_travel.visible = false
		return

## Is called when the map travel scene is closed via the MapTravel signal.
func _on_scene_map_travel_closed() -> void:
	_map_travel_scene_call()

func _show_game_contextual_menus(value: bool) -> void:
	context_menu_layer.visible = value
	
## INFO: Does not account for POVSwitch, Camera and MapTravel
func _any_menu_opened(node: Control) -> void:
	Events.any_menu_opened(node)

func _on_open_save_menu() -> void:
	save_load_menu.show_save_load_menu(SaveLoadMenu.ContextualType.SAVING)

func _on_open_load_menu() -> void:
	save_load_menu.show_save_load_menu(SaveLoadMenu.ContextualType.LOADING)

	
#endregion


#func _on_settings_opened() -> void:
	#$Settings/Pause._on_button_toggled(true)
