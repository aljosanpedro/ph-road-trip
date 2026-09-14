@icon("res://nodes/command_wait.svg")

class_name WaitCommand
extends Commands

# The amount of seconds to wait... in milliseconds.
@export var seconds: float = 0

@warning_ignore("unused_parameter")
func execute(node: MapEventBase) -> bool:
	await Events.wait(seconds)
	return true
