extends Node2D

# List of interactables
# for wiks:
# **stall**
# **sunken_garden**
# **adis_mural**
# for adi:
# **trees**
# **loose_chicken**

func _ready() -> void:
	print("Now arriving at: " + name)
	Dialogic.start("res://assets/dialogue/location_1/loc_1_scene.dtl", "intro")
	await Dialogic.timeline_ended
