@icon("res://nodes/command_sfx.svg")

class_name StopSFXAllCommand
extends Commands

func execute() -> bool:
	AudioManager.sfx_stop_all()
	return true
