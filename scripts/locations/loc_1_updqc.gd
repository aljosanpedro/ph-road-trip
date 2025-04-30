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

func _on_chicken_item_clicked() -> void:
	Dialogic.start("res://assets/dialogue/location_1/loc_1_interactables.dtl", "loose_chicken")

func _on_stall_item_clicked() -> void:
	Dialogic.start("res://assets/dialogue/location_1/loc_1_interactables.dtl", "stall")

func _on_adis_mural_item_clicked() -> void:
	Dialogic.start("res://assets/dialogue/location_1/loc_1_interactables.dtl", "adis_mural")

func _on_trees_item_clicked() -> void:
	Dialogic.start("res://assets/dialogue/location_1/loc_1_interactables.dtl", "trees")

func _on_sunken_garden_item_clicked() -> void:
	Dialogic.start("res://assets/dialogue/location_1/loc_1_interactables.dtl", "sunken_garden")
