@icon("res://nodes/loc_1_updqc.svg")

class_name UPDQC
extends Node2D

@onready var background = $Background
@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	animation_player.play("RESET")

# If everything is interacted.
func _is_everything_interacted() -> void:
	var relevant_switches = [
		"loc_1_stall",
		"loc_1_sunken_garden",
		"loc_1_adis_mural",
		"loc_1_trees",
		"loc_1_loose_chicken"
	]
	
	# If not all are interacted, return.
	for switches in relevant_switches:
		if not DataManager.get_switch(switches): return
	
	# Initiate outro if true...
	Dialogic.start("res://assets/dialogue/location_1/loc_1_scene.dtl", "outro_pre_camera")
	await Dialogic.timeline_ended
	
	# Initiate camera...
	Events.open_camera()
	await Events.camera_photo_taken
	
	# Stop music after photo is taken.
	AudioManager.bgm_stop(1)
	
	# Delete all items instead.
	for item in get_children():
		if item is ItemBase:
			item.queue_free()
	
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	
	# Initiate after camera photo taken.
	Dialogic.start("res://assets/dialogue/location_1/loc_1_scene.dtl", "outro_post_camera")
	await Dialogic.timeline_ended
	
	# Then, enable Route.
	Events.enable_route(Events.Locations.Cubao)
	
	# Call map.
	Events.show_travel_map_scene()
	
