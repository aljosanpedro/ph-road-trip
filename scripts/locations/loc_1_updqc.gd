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

func _on_character_item_clicked() -> void:
	Dialogic.start("debug")
	#match Events.get_current_pov():
		#Events.POV_Character.adi:
			#pass
		#Events.POV_Character.wiks:
			#pass
