@icon("res://nodes/command_bgs.svg")

class_name StopBGSCommand
extends Commands

func execute(node: MapEventBase) -> bool:
	AudioManager.bgs_stop()
	return true
