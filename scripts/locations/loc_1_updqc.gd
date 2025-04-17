extends Node2D

func _ready() -> void:
	print("Now arriving at: " + name)

func _on_character_item_clicked() -> void:
	Dialogic.start("res://assets/dialogue/debug.dtl")
	#match Events.get_current_pov():
		#Events.POV_Character.ADI:
			#pass
		#Events.POV_Character.WIKS:
			#pass
