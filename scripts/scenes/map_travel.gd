extends Control


func _on_visibility_changed() -> void:
	if visible:
		mouse_filter = Control.MOUSE_FILTER_STOP
	else: 
		mouse_filter = Control.MOUSE_FILTER_IGNORE
