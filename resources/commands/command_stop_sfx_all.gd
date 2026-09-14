@icon("res://nodes/command_sfx.svg")

class_name StopSFXAllCommand
extends Commands

func execute(node: MapEventBase) -> bool:
	AudioManager.sfx_stop_all()
	return true
