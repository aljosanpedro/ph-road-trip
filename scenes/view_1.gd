extends Node2D

func _ready() -> void:
	get_node(".").visible = false

func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_node(".").visible = false
	else: 
		get_node(".").visible = true
