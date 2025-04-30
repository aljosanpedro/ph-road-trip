extends Node2D

# List of interactables
# For wiks:
# 	kids_playing
# 	lanterns
# 	radio
# For adi:
# 	mannequins
# 	jabee

func _ready() -> void:
	print("Now arriving at: " + name)
	Dialogic.start("res://assets/dialogue/intro/intro.dtl")
	await Dialogic.timeline_ended
