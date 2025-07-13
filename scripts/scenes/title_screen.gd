@icon("res://icon.svg")

class_name TitleScreen
extends Control

@onready var animation_player = $AnimationPlayer
@onready var main_menu_buttons: HBoxContainer = $MainMenuButtons

func _ready() -> void:
	AudioManager.bgm_play("res://assets/audio/bgm/title_theme.mp3")
	modulate = Color(0, 0, 0)
	animation_player.play("intro")
	
	await animation_player.animation_finished
	
	for game_button: Button in main_menu_buttons.get_children():
		game_button.disabled = false

func _on_start_game_pressed() -> void:
	AudioManager.bgm_stop(1)
	animation_player.play("fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/scenes/game_main.tscn")

#func _game_button_mouse_entered(the_button: Button) -> void:
	#the_button.shader
#
#func _game_button_mouse_exited(the_button: Button) -> void:
	#pass
	#
