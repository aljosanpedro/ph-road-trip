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
	
	# In the possibility that, when you load in and there's no triggers, it will
	# activate the following.
	
## Used in order to detect any sort of changes in the game.
func _observing_triggers() -> void:
	for i in range(event_page_list.size() - 1, -1, -1):
		var event_page: EventPage = event_page_list[i]
		if _meets_conditions(event_page):
			print("Event page activated")
			_activate_event_page(event_page)
			
			# Only run once. Duh
			break

# Check conditions through a rather fun way.
func _meets_conditions(event_page: EventPage) -> bool:
	var switches_ok = event_page.switch_trigger.all(func(s): return DataManager.get_switch(s))
	var variables_ok = event_page.variable_trigger.all(func(v: VariableCondition): return v.is_met())
	var self_switches_ok = event_page.self_switch_trigger.all(func(s): return DataManager.get_self_switch(s))
	return switches_ok and variables_ok and self_switches_ok

# Runs the event itself.
func _activate_event_page(event_page: EventPage) -> void:
	for command in event_page.commands:
		if command is EndEventCommand: break
		@warning_ignore("redundant_await")
		await command.execute(self)
