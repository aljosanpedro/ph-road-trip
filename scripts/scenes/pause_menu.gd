@icon("res://nodes/pause_menu.svg")

class_name PauseMenu
extends Control

@onready var play_button: Button = $PlayButton
@onready var pause_button: Button = $PauseButton
@onready var pause_menu_items: Control = $PauseMenuItems

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	play_button.hide()
	pause_menu_items.hide()
	pause_button.show()

func _on_play_button_pressed() -> void:
	if animation_player.is_playing(): return
	
	play_button.hide()
	pause_button.show()

	animation_player.play_backwards("show_menu")
	await animation_player.animation_finished

	pause_menu_items.hide()
	pause_menu_items.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_pause_button_pressed() -> void:
	if animation_player.is_playing(): return
	
	play_button.show()
	pause_menu_items.show()
	pause_button.hide()

	animation_player.play("show_menu")
	await animation_player.animation_finished
	
	pause_menu_items.mouse_filter = Control.MOUSE_FILTER_STOP
