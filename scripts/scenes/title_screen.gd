@icon("res://icon.svg")

class_name TitleScreen
extends Control

@onready var animation_player = $AnimationPlayer
@onready var main_menu_buttons: HBoxContainer = $CanvasLayer/UIAndEverything/MainMenuButtons

@onready var pause_menu: PauseMenu = $CanvasLayer/UIAndEverything/PauseMenu

func _ready() -> void:
	Dialogic.end_timeline()
	
	AudioManager.bgm_play("res://assets/audio/bgm/title_theme.mp3")
	modulate = Color(0, 0, 0)
	animation_player.play("intro")
	
	await animation_player.animation_finished
	
	for game_button: Button in main_menu_buttons.get_children():
		game_button.focus_entered.connect(_title_button_focus_entered.bind(game_button))
		game_button.focus_exited.connect(_title_button_focus_exited.bind(game_button))
		game_button.disabled = false

func _on_start_game_pressed() -> void:
	_activate_buttons(false)
	AudioManager.bgm_stop(1)
	animation_player.play("fade")
	await animation_player.animation_finished
	
	get_tree().change_scene_to_packed(preload("res://scenes/scenes/game_main.tscn"))

func _on_quit_game_pressed() -> void:
	_activate_buttons(false)
	AudioManager.bgm_stop(1)
	animation_player.play("fade")
	await animation_player.animation_finished
	
	get_tree().quit()

func _on_options_pressed() -> void:
	pause_menu.show_settings()

func _activate_buttons(value: bool) -> void:
	for game_button: Button in main_menu_buttons.get_children():
		game_button.use_parent_material = value
		
func _title_button_focus_entered(game_button: Button) -> void:
	game_button.use_parent_material = true

func _title_button_focus_exited(game_button: Button) -> void:
	game_button.use_parent_material = true
		
