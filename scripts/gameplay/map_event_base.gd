@icon("res://nodes/map_event.svg")
#==============================================================================
# ** MapEventBase
#------------------------------------------------------------------------------
# This class handles how events work all around gameplay. This essentially makes
# events custom and modular for easy editing, as opposed to the static design
# that it originally had.
#==============================================================================

class_name MapEventBase
extends Node2D

## The page list to run. It will run the bottom-most first, and then stop.
@export var event_page_list: Array[EventPage]

## Used to track the current command that is running.
var index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DataManager.data_changed.connect(_observing_triggers)

# DEPRECATED: Would like to use this... but you know what would happen honestly.
# Plus, observer paradigm is a thing... so why are we trying to chase race
# conditions?
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

## Used in order to detect any sort of changes in the game.
func _observing_triggers() -> void:
	for event_page: EventPage in event_page_list:
		event_page.trigger
