@icon("res://nodes/event_page.svg")
#==============================================================================
class_name EventPage
extends Resource
#------------------------------------------------------------------------------
# This resouce handles basically how an event page can occur in the game. This
# is inspired (or based) from the RPG Maker engines. An event can have multiple
# event pages alone for that fact.
#
# Event pages will NOT run the commands, but rather the events themselves!
#
#==============================================================================

enum TRIGGER_TYPE {
	## If CONTACT, player input is required.
	CONTACT,
	## If AUTORUN, will execute and then end.
	AUTORUN,
	## If PARALLEL, will execute and end only when event is forced out.
	PARALLEL
}

@export_category("Triggers")
## Switches required to activate this event page.
@export var switch_trigger: Array[DataManager.SWCH_NAME]
## Variables required to activate this event page.
@export var variable_trigger: Array[DataManager.VAR_NAME]
## Self-switches required to activate this event page.
@export var self_switch_trigger: Array[String]

@export_category("Properties")
@export var trigger: TRIGGER_TYPE

@export_category("Commands")
## Commands to run for this event page.
@export var commands: Array[Commands]
