@icon("res://nodes/command_camera.svg")

class_name OpenCameraCommand
extends Commands

@warning_ignore("unused_parameter")
func execute(node: MapEventBase) -> bool:
	Events.open_camera()
	await Events.camera_photo_taken
	return true
