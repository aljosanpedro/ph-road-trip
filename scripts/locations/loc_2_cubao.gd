@icon("res://nodes/loc_2_cubao.svg")

class_name Cubao
extends Node2D

@onready var background = $Background
@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	animation_player.play("RESET")
	#AudioManager.bgm_play("res://assets/audio/bgm/cubao_2.mp3")
	#animation_player.play("RESET")
	## Connect a following switch.
	#DataManager.data_changed.connect(_is_everything_interacted)
	#
	## Hide item outlines at first.
	#Events.show_item_outline(false)
	#
	## Set dialogue immediately.
	#Dialogic.start("res://assets/dialogue/location_2/loc_2_scene.dtl", "intro")
	#await Dialogic.timeline_ended
	#
	#
	#Events.show_the_context_menus(true) # By default, as intro will flick it up.
	#Events.show_item_outline(true) # Interactables will now have outlines.
	


# If everything is interacted.
#func _is_everything_interacted() -> void:
	#var relevant_switches = [
		#"loc_2_kids_playing",
		#"loc_2_lanterns",
		#"loc_2_radio",
		#"loc_2_graffiti",
		#"loc_2_clothes",
		#"loc_2_mannequins",
		#"loc_2_jabee"
	#]
	#
	## If not all are interacted, return.
	#for switches in relevant_switches:
		#if not DataManager.get_switch(switches): return
	#
	## Initiate outro if true...
	#Dialogic.start("res://assets/dialogue/location_2/loc_2_scene.dtl", "outro_pre_camera")
	#await Dialogic.timeline_ended
	#
	## Initiate camera...
	#Events.open_camera()
	#await Events.camera_photo_taken
	#
	## Stop music after photo is taken.
	#AudioManager.bgm_stop(1)
	#
	## Delete all items instead.
	#for item in get_children():
		#if item is ItemBase:
			#item.queue_free()
	#
	#animation_player.play("fade_to_black")
	#await animation_player.animation_finished
	#
	## Initiate after camera photo taken.
	#Dialogic.start("res://assets/dialogue/location_2/loc_2_scene.dtl", "outro_post_camera")
	#await Dialogic.timeline_ended
	#
	## Then, enable Route.
	#Events.enable_route(Events.Locations.Makati)
	#
	## Call map.
	#Events.show_travel_map_scene()
	#
	## Disconnect to never let it fire again.
	#DataManager.data_changed.disconnect(_is_everything_interacted)
