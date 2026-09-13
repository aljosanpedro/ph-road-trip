@icon("res://nodes/command_message.svg")

class_name DialogueCommand
extends Commands

## Dialogic file to target
@export var dialogic_file: DialogicTimeline
## Label where to start the entire timeline.
@export var label: String = ""

func execute() -> bool:
	Dialogic.start(dialogic_file, label)
	await Dialogic.timeline_ended
	return true
