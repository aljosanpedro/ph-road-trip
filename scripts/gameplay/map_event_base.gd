@icon("res://nodes/map_event.svg")
#==============================================================================
# ** MapEventBase
#------------------------------------------------------------------------------
# This class handles how events work all around gameplay. This essentially makes
# events custom and modular for easy editing, as opposed to the static design
# that it originally had.
#==============================================================================

class_name MapEventBase
extends Area2D

## The page list to run. It will run the bottom-most first, and then stop.
@export var event_page_list: Array[EventPage]

## Used to track the current command that is running.
var index: int = 0
## Event page that will be used.
var current_page: EventPage
## Semiotic lock... kinda.
var lock: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DataManager.data_changed.connect(_find_suitable_page)
	
	# Making sure every map event has at least a page, even if it is empty.
	assert(event_page_list.size() > 0, "ERROR: You forgot to add in an event page!")
	
	# In the possibility that, when you load in and there's no triggers, it will
	# activate the following.
	_find_suitable_page()

func _process(_delta: float) -> void:
	if current_page:
		if current_page.trigger == EventPage.TRIGGER_TYPE.AUTORUN:
			_activate_event_page(current_page)
		elif current_page.trigger == EventPage.TRIGGER_TYPE.PARALLEL:
			_activate_event_page(current_page)

# When DataManager changes, find a better page host.
func _find_suitable_page() -> void:
	for i in range(event_page_list.size() - 1, -1, -1):
		var event_page: EventPage = event_page_list[i]
		if _meets_conditions(event_page):
			current_page = event_page
			break

# Check conditions through a rather fun way.
func _meets_conditions(event_page: EventPage) -> bool:
	var switches_ok = event_page.switch_triggers.all(func(s): return DataManager.get_switch(s))
	var variables_ok = event_page.variable_triggers.all(func(v: VariableCondition): return v.is_met())
	var self_switches_ok = event_page.self_switch_triggers.all(func(s): return DataManager.get_self_switch(s))
	return switches_ok and variables_ok and self_switches_ok

# Runs the event itself.
func _activate_event_page(event_page: EventPage) -> void:
	# Disrupt any attempt to run the event page if another event page is
	# already running.
	if lock: return
	
	lock = true
	index = 0
	
	for command in event_page.commands:
		index += 1 
		if command is EndEventCommand: break
		
		# Debugging
		print("Running command: ", command.get_class())
		
		@warning_ignore("redundant_await")
		await command.execute(self)
	
	lock = false

# Run the interaction.
func interact() -> void:
	if current_page and current_page.trigger == EventPage.TRIGGER_TYPE.CONTACT:
		_activate_event_page(current_page)
