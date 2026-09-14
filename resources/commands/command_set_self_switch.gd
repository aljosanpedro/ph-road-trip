@icon("res://nodes/command_set_self_switch.svg")

class_name SetSelfSwitchCommand
extends Commands

## Switch to change status.
@export var switch: String
@export var value: bool = false

@warning_ignore("unused_parameter")
func execute(node: MapEventBase) -> bool:
	# Set up hash.
	var hash_key: String = node.get_parent().name + node.name + switch
	
	DataManager.set_self_switch(hash_key, value)
	return true
