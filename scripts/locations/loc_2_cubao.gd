@icon("res://nodes/loc_2_cubao.svg")

class_name Cubao
extends Node2D

@onready var background = $Background
@onready var animation_player = $AnimationPlayer

# List of interactables
# For wiks:
# 	kids_playing
# 	lanterns
# 	radio
# For adi:
#	graffiti
#	clothes
# 	mannequins
# 	jabee
# "loc_2_kids_playing": false,
# "loc_2_lanterns": false,
# "loc_2_radio": false,
# "loc_2_graffiti": false,
# "loc_2_clothes": false,
# "loc_2_mannequins": false,
# "loc_2_jabee": false,

func _ready() -> void:
	AudioManager.bgm_play("res://assets/audio/bgm/amynlrpfbtwaves.mp3")
	animation_player.play("RESET")
	# Connect a following switch.
	Events.switch_has_been_set.connect(_is_everything_interacted)
	
	# Hide item outlines at first.
	Events.show_item_outline(false)
	
	# Set dialogue immediately.
	Dialogic.start("res://assets/dialogue/location_2/loc_2_scene.dtl", "intro")
	await Dialogic.timeline_ended
	
	Events.show_the_context_menus(true) # By default, as intro will flick it up.
	Events.show_item_outline(true) # Interactables will now have outlines.

# If everything is interacted.
func _is_everything_interacted() -> void:
	var relevant_switches = [
		"loc_2_kids_playing",
		"loc_2_lanterns",
		"loc_2_radio",
		"loc_2_graffiti",
		"loc_2_clothes",
		"loc_2_mannequins",
		"loc_2_jabee"
	]
	
	# If not all are interacted, return.
	for switches in relevant_switches:
		if not Events.get_switch(switches): return
	
	# Initiate outro if true...
	Dialogic.start("res://assets/dialogue/location_2/loc_2_scene.dtl", "outro_pre_camera")
	await Dialogic.timeline_ended
	
	# Initiate camera...
	Events.open_camera()
	await Events.camera_photo_taken
	
	# Stop music after photo is taken.
	AudioManager.bgm_stop(1)
	
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	
	# Initiate after camera photo taken.
	Dialogic.start("res://assets/dialogue/location_2/loc_2_scene.dtl", "outro_post_camera")
	await Dialogic.timeline_ended
	
	# Then, enable Route.
	Events.enable_route(Events.Locations.Makati)
	
	# Call map.
	Events.show_travel_map_scene()
	
	# Disconnect to never let it fire again.
	Events.switch_has_been_set.disconnect(_is_everything_interacted)

#region Interactable
func _on_graffiti_item_clicked() -> void:
	Events.show_item_outline(false)
	Dialogic.start("res://assets/dialogue/location_2/loc_2_interactables.dtl", "graffiti")
	await Dialogic.timeline_ended
	Events.show_item_outline(true)
	Events.set_switch("loc_2_graffiti", true)


func _on_jolibee_item_clicked() -> void:
	Events.show_item_outline(false)
	Dialogic.start("res://assets/dialogue/location_2/loc_2_interactables.dtl", "jabee")
	await Dialogic.timeline_ended
	Events.show_item_outline(true)
	Events.set_switch("loc_2_jabee", true)


func _on_lanterns_item_clicked() -> void:
	Events.show_item_outline(false)
	Dialogic.start("res://assets/dialogue/location_2/loc_2_interactables.dtl", "lanterns")
	await Dialogic.timeline_ended
	Events.show_item_outline(true)
	Events.set_switch("loc_2_lanterns", true)


func _on_radio_item_clicked() -> void:
	Events.show_item_outline(false)
	Dialogic.start("res://assets/dialogue/location_2/loc_2_interactables.dtl", "radio")
	await Dialogic.timeline_ended
	Events.show_item_outline(true)
	Events.set_switch("loc_2_radio", true)


func _on_kids_item_clicked() -> void:
	Events.show_item_outline(false)
	Dialogic.start("res://assets/dialogue/location_2/loc_2_interactables.dtl", "kids_playing")
	await Dialogic.timeline_ended
	Events.show_item_outline(true)
	Events.set_switch("loc_2_kids_playing", true)


func _on_mannequins_item_clicked() -> void:
	Events.show_item_outline(false)
	Dialogic.start("res://assets/dialogue/location_2/loc_2_interactables.dtl", "mannequins")
	await Dialogic.timeline_ended
	Events.show_item_outline(true)
	Events.set_switch("loc_2_mannequins", true)


func _on_clothesline_item_clicked() -> void:
	Events.show_item_outline(false)
	Dialogic.start("res://assets/dialogue/location_2/loc_2_interactables.dtl", "clothes")
	await Dialogic.timeline_ended
	Events.show_item_outline(true)
	Events.set_switch("loc_2_clothes", true)
	
#endregion
