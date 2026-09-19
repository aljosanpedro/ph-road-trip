@icon("res://nodes/command_template.svg")

class_name ParentCallFunctionCommand
extends Commands

## Name of the function to call
@export var function_name: String
## Arguments for the following.
@export var arguments: Array[String]

@warning_ignore("unused_parameter")
func execute(node: MapEventBase) -> bool:
	var callable = Callable(node.get_parent(), function_name)
	callable.call(arguments)
	return true
