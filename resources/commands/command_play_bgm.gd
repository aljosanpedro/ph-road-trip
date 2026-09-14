@icon("res://nodes/command_bgm.svg")

class_name PlayBGMCommand
extends Commands

## Audio file to play
@export_file("*.mp3","*.wav","*.ogg") var audio_file
## Volume to use
@export var volume: float = 0.0

@warning_ignore("unused_parameter")
func execute(node: MapEventBase) -> bool:
	AudioManager.bgm_play(audio_file, volume)
	return true
