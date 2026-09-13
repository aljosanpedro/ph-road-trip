#==============================================================================
# ** DataManager
#------------------------------------------------------------------------------
# This module manages the database and game objects. Almost all of the 
# global variables used by the game are initialized by this module.
#
# This is all index based!
#==============================================================================

extends Node

enum SWCH_NAME {
	LOC_1_STALL,
	LOC_1_SUNKEN_GARDEN,
	LOC_1_ADIS_MURAL,
	LOC_1_TREES,
	LOC_1_LOOSE_CHICKEN,
	LOC_2_KIDS_PLAYING,
	LOC_2_LANTERNS,
	LOC_2_RADIO,
	LOC_2_GRAFFITI,
	LOC_2_CLOTHES,
	LOC_2_MANNEQUINS,
	LOC_2_JABEE
}

enum VAR_NAME {
	VAR_1,
	VAR_2,
}

var _switches: Dictionary[SWCH_NAME, bool] = {}
var _variables: Dictionary[VAR_NAME, Variant] = {}
# A set of combination of [SceneName] + [EventName] + [SelfSwitch]
var _self_switches: Dictionary[String, bool] = {}

# All Signals
signal data_changed

## Initializes everything.
func _init() -> void:
	# Initialize _switches
	for id in SWCH_NAME.values():
		_switches[id] = false
	
	# Initialize _variables
	for id in VAR_NAME.values():
		_variables[id] = 0
	
	print(_switches)
	print(_variables)

## Get the value of a switch.
func get_switch(id: SWCH_NAME) -> bool:
	return _switches.get(id, false)

## Set up the boolean for a switch.
func set_switch(id: SWCH_NAME, value: bool) -> void:
	# Return if we're just going to do the same thing.
	if _switches.get(id, false) == value: return
	
	# Set switch.
	_switches[id] = value
	
	data_changed.emit()

## Get the value of a variable.
func get_variable(id: VAR_NAME) -> Variant:
	return _variables.get(id, 0)

## Get the value of a variable.
func set_variable(id: VAR_NAME, value: Variant) -> void:
	# Return if we're just going to do the same thing.
	#if _variables.get(id, false) == value: return
	
	# Set switch.
	_variables[id] = value

## Get the value of a self-switch.
## Key: [SceneName] + [EventName] + [SelfSwitch]
func get_self_switch(key: String) -> bool:
	return _self_switches.get(key, false)

## Set up the boolean for a self-switch.
## Key: [SceneName] + [EventName] + [SelfSwitch]
func set_self_switch(key: String, value: bool) -> void:
	# Return if we're just going to do the same thing.
	if _self_switches.get(key, false) == value: return
	
	# Set switch.
	_self_switches[key] = value
