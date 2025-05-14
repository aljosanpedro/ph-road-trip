extends Node2D
# List of interactables
# For wiks:
# 	kids_playing
# 	lanterns
# 	radio
# For adi:
#	graffiti
#	clothes
# 	mannequins
# 	jabee
# "loc_2_kids_playing": false,
# "loc_2_lanterns": false,
# "loc_2_radio": false,
# "loc_2_graffiti": false,
# "loc_2_clothes": false,
# "loc_2_mannequins": false,
# "loc_2_jabee": false,

func _ready() -> void:
	print("Now arriving at: " + name)
	#Events.open_camera()
