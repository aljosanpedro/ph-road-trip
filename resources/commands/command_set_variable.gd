@icon("res://nodes/command_set_variable.svg")

class_name SetVariableCommand
extends Commands

## Switch to change status.
@export var variable: DataManager.VAR_NAME
@export var value: Variant

@warning_ignore("unused_parameter")
func execute(node: MapEventBase) -> bool:
	DataManager.set_variable(variable, value)
	return true
