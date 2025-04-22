extends Node2D

func _ready() -> void:
	print("Now arriving at: " + name)
	Events.open_camera()
