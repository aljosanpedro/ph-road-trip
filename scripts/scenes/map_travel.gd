@icon("res://nodes/map.svg")

class_name MapTravel
extends Control

#region Initialized Variables and Exports
signal scene_map_travel_closed
# INFO: Locational buttons
@onready var location_1_updqc = $"UPD-QC"
@onready var location_2_cubao = $Cubao
@onready var location_3_makati = $Makati
@onready var location_4_quiapo = $Quiapo
@onready var location_5_coast = $Coast
@onready var location_6_jabee = $Jabee

@onready var animation_player = $AnimationPlayer

@onready var player_marker = $CurrentLocationPlayer
@onready var target_area = $TargetArea
@onready var location_label = $LocationLabel

#endregion

#region Virtual functions
func _ready() -> void:
	_disable_all_routes()
	
	# Connect event.
	Events.unlock_location.connect(_enable_route)

	# WARNING: This is Cthulhu magic at this point.
	# Connecting the hard way.
	for target_loc in get_tree().get_nodes_in_group("locations"):
		target_loc.pressed.connect(_on_location_pressed.bind(target_loc))
		target_loc.mouse_entered.connect(_on_loc_mouse_entered.bind(target_loc))
		target_loc.mouse_exited.connect(_on_loc_mouse_exited.bind(target_loc))
		
func _on_visibility_changed() -> void:
	if visible:
		mouse_filter = Control.MOUSE_FILTER_STOP
		
	else: 
		mouse_filter = Control.MOUSE_FILTER_IGNORE

## When pressing location, change player marker location and switch scene.
func _on_location_pressed(button: TextureButton) -> void:
	Events.change_area(button.location.resource_path)
	player_marker.position = Vector2(button.position.x, button.position.y)
	scene_map_travel_closed.emit()

## Basically, when hovering over a location, change target area location.
func _on_loc_mouse_entered(button: TextureButton) -> void:
	if button.disabled: return
	location_label.text = button.name
	target_area.position = Vector2(button.position.x - 3, button.position.y - 36)
	target_area.show()

func _on_loc_mouse_exited(button: TextureButton) -> void:
	if button.disabled: return
	if not Rect2(Vector2(), button.size).has_point(get_local_mouse_position()):
		location_label.text = "???"
		target_area.hide()

func _enable_route(value: Events.Locations) -> void:
	_disable_all_routes()
	match value:
		Events.Locations.UPDQC:
			location_1_updqc.enable_button(true)
		Events.Locations.Cubao:
			location_2_cubao.enable_button(true)
		Events.Locations.Makati:
			location_3_makati.enable_button(true)
		Events.Locations.Quiapo:
			location_4_quiapo.enable_button(true)
		Events.Locations.Coast:
			location_5_coast.enable_button(true)
		Events.Locations.Jabee:
			location_6_jabee.enable_button(true)

## Just a nifty thing to make everything concise <3.	
func _disable_all_routes() -> void:
	location_1_updqc.enable_button(false)
	location_2_cubao.enable_button(false)
	location_3_makati.enable_button(false)
	location_4_quiapo.enable_button(false)
	location_5_coast.enable_button(false)
	location_6_jabee.enable_button(false)
#endregion
