@icon("res://icon.svg")

class_name TitleScreen
extends Control

@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	AudioManager.bgm_play("res://assets/audio/bgm/title_theme.mp3")
	modulate = Color(0, 0, 0)
	animation_player.play_backwards("fade")

func _on_start_game_pressed() -> void:
	AudioManager.bgm_stop(1)
	animation_player.play("fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/scenes/game_main.tscn")
