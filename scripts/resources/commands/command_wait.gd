@icon("res://nodes/command_wait.svg")

class_name WaitCommand
extends Resource

# The amount of seconds to wait... in milliseconds.
@export var seconds: float = 0

func execute() -> bool:
	await Events.wait(seconds)
	return true
