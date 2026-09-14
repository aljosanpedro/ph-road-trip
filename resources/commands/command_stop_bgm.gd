@icon("res://nodes/command_bgm.svg")

class_name StopBGMCommand
extends Commands

## Seconds to fade out from.
@export var fade: float = 0.0

func execute(node: MapEventBase) -> bool:
	AudioManager.bgm_stop(fade)
	return true
