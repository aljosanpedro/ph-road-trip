@icon("res://nodes/loc_3_makati.svg")

class_name Makati
extends Node2D

func _ready() -> void:
	# Connect a following switch.
	#Events.switch_has_been_set.connect(_is_everything_interacted)
	
	# Hide item outlines at first.
	Events.show_item_outline(false)
	Events.show_the_context_menus(false) # End of demo.
	
	# Set dialogue immediately.
	Dialogic.start("res://assets/dialogue/end_of_demo.dtl")
	await Dialogic.timeline_ended
	
	Events.reset()
	get_tree().change_scene_to_packed(load("res://scenes/scenes/title_screen.tscn"))
	
	#Events.show_the_context_menus(true) # By default, as intro will flick it up.
	#Events.show_item_outline(true) # Interactables will now have outlines.
