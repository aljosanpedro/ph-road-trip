extends Node2D

# List of interactables
# For Wiks:
# 	kids_playing
# 	lanterns
# 	radio
# For Adi:
# 	mannequins
# 	jabee

func _ready() -> void:
	print("Now arriving at: " + name)

func _on_character_item_clicked() -> void:
	Dialogic.start("debug")
	#match Events.get_current_pov():
		#Events.POV_Character.ADI:
			#pass
		#Events.POV_Character.WIKS:
			#pass
