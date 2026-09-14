@icon("res://nodes/command_bgs.svg")

class_name StopBGSCommand
extends Commands

@warning_ignore("unused_parameter")
func execute(node: MapEventBase) -> bool:
	AudioManager.bgs_stop()
	return true
