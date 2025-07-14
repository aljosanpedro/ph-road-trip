@icon("res://nodes/pause_menu.svg")

class_name PauseMenu
extends Control

@onready var play_button: Button = $PlayButton
@onready var pause_button: Button = $PauseButton
@onready var pause_menu_items: Control = $PauseMenuItems

func _ready() -> void:
	_on_play_button_pressed()	

func _on_play_button_pressed() -> void:
	play_button.hide()
	pause_menu_items.hide()
	
	pause_button.show()

	pause_menu_items.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_pause_button_pressed() -> void:
	play_button.show()
	pause_menu_items.show()
	
	pause_button.hide()
	
	pause_menu_items.mouse_filter = Control.MOUSE_FILTER_STOP
