@icon("res://nodes/command_bgs.svg")

class_name PlayBGSCommand
extends Commands

## Audio file to play
@export_file("*.mp3","*.wav","*.ogg") var audio_file
## Volume to use
@export var volume: float = 0.0

func execute() -> bool:
	AudioManager.bgs_play(audio_file)
	AudioManager.bgs_volume(volume)
	return true
