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

## What counts as triggers to activate stuff.
@export var switch_trigger: Array[DataManager.SWCH_NAME]
@export var variable_trigger: Array[DataManager.VAR_NAME]

## Used to track the current event that is running.
var index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
