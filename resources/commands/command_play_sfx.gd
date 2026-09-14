@icon("res://nodes/command_sfx.svg")

class_name PlaySFXCommand
extends Commands

## Audio file to play
@export_file("*.mp3","*.wav","*.ogg") var audio_file

@warning_ignore("unused_parameter")
func execute(node: MapEventBase) -> bool:
	AudioManager.sfx_play(audio_file)
	return true
