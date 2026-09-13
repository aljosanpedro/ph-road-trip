@icon("res://nodes/command_sfx.svg")

class_name PlaySFXCommand
extends Commands

## Audio file to play
@export_file("*.mp3","*.wav","*.ogg") var audio_file

func execute() -> bool:
	AudioManager.sfx_play(audio_file)
	return true
