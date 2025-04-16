extends Control

#region Initialized Variables and Exports
signal scene_map_travel_closed
# INFO: Locational buttons
@onready var location_1_updqc = $UPDQC
@onready var location_2_cubao = $Cubao
@onready var location_3_makati = $Makati
@onready var location_4_quiapo = $Quiapo
@onready var location_5_coast = $Coast

#endregion

func _ready() -> void:
	location_1_updqc.enable_button(true)
	location_2_cubao.enable_button(true)
	location_3_makati.enable_button(true)
	location_4_quiapo.enable_button(true)
	location_5_coast.enable_button(true)

func _on_visibility_changed() -> void:
	if visible:
		mouse_filter = Control.MOUSE_FILTER_STOP
	else: 
		mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_location_pressed() -> void:
	scene_map_travel_closed.emit()
