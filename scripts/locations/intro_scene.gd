extends Node2D

func _ready() -> void:
	_intro()
	
## Call upon intro to start the game.
func _intro() -> void:
	AudioManager.bgm_play("res://assets/audio/bgm/shell.mp3")
	
	# Call Dialogic
	Dialogic.start("res://assets/dialogue/intro/intro.dtl")
	await Dialogic.timeline_ended
	
	AudioManager.bgm_stop(1)
	Events.change_area("res://scenes/locations/loc1_updqc.tscn")
	
	#Events.show_the_context_menus(true) # By default, as intro will flick it up.
	
