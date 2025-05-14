extends Node2D
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
	
	# Initiate after camera photo taken.
	Dialogic.start("res://assets/dialogue/location_2/loc_2_scene.dtl", "outro_post_camera")
	await Dialogic.timeline_ended
	
	# Then, enable Route.
	Events.enable_route(Events.Locations.Cubao)
	
	# Call map.
	Events.show_travel_map_scene()
	
	# Disconnect to never let it fire again.
	Events.switch_has_been_set.disconnect(_is_everything_interacted)

#region Interactable



#endregion
