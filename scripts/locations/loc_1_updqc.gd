@icon("res://nodes/loc_1_updqc.svg")

class_name UPDQC
extends Node2D

@onready var background = $Background
@onready var animation_player = $AnimationPlayer
# List of interactables
# for wiks:
# **stall**
# **sunken_garden**
# **adis_mural**
# for adi:
# **trees**
# **loose_chicken**
#"loc_1_stall": false,
#"loc_1_sunken_garden": false,
#"loc_1_adis_mural": false,
#"loc_1_trees": false,
#"loc_1_loose_chicken": false,

func _ready() -> void:
	animation_player.play("RESET")
	
	# Connect a following switch.
	Events.switch_has_been_set.connect(_is_everything_interacted)
	
	# Hide item outlines at first.
	Events.show_item_outline(false)
	
	# Set dialogue immediately.
	Dialogic.start("res://assets/dialogue/location_1/loc_1_scene.dtl", "intro")
	await Dialogic.timeline_ended
	
	Events.show_the_context_menus(true) # By default, as intro will flick it up.
	Events.show_item_outline(true) # Interactables will now have outlines.

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
		if not Events.get_switch(switches): return
	
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
	
	# Disconnect to never let it fire again.
	Events.switch_has_been_set.disconnect(_is_everything_interacted)

#region Interactable
func _on_chicken_item_clicked() -> void:
	if Events.get_switch("loc_1_loose_chicken"): 
		Events.item_already_interacted()
		return
	
	Events.show_item_outline(false)
	Dialogic.start("res://assets/dialogue/location_1/loc_1_interactables.dtl", "loose_chicken")
	await Dialogic.timeline_ended
	Events.show_item_outline(true)
	Events.set_switch("loc_1_loose_chicken", true)

func _on_stall_item_clicked() -> void:
	if Events.get_switch("loc_1_stall"): 
		Events.item_already_interacted()
		return
	
	Events.show_item_outline(false)
	Dialogic.start("res://assets/dialogue/location_1/loc_1_interactables.dtl", "stall")
	await Dialogic.timeline_ended
	Events.show_item_outline(true)
	Events.set_switch("loc_1_stall", true)

func _on_adis_mural_item_clicked() -> void:
	if Events.get_switch("loc_1_adis_mural"): 
		Events.item_already_interacted()
		return
	
	Events.show_item_outline(false)
	Dialogic.start("res://assets/dialogue/location_1/loc_1_interactables.dtl", "adis_mural")
	await Dialogic.timeline_ended
	Events.show_item_outline(true)
	Events.set_switch("loc_1_adis_mural", true)

func _on_trees_item_clicked() -> void:
	if Events.get_switch("loc_1_trees"): 
		Events.item_already_interacted()
		return
	
	Events.show_item_outline(false)
	Dialogic.start("res://assets/dialogue/location_1/loc_1_interactables.dtl", "trees")
	await Dialogic.timeline_ended
	Events.show_item_outline(true)
	Events.set_switch("loc_1_trees", true)

func _on_sunken_garden_item_clicked() -> void:
	if Events.get_switch("loc_1_sunken_garden"): 
		Events.item_already_interacted()
		return
	
	Events.show_item_outline(false)
	Dialogic.start("res://assets/dialogue/location_1/loc_1_interactables.dtl", "sunken_garden")
	await Dialogic.timeline_ended
	Events.show_item_outline(true)
	Events.set_switch("loc_1_sunken_garden", true)


#endregion
