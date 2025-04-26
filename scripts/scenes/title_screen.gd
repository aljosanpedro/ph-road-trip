extends Control

@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	modulate = Color(0, 0, 0)
	animation_player.play_backwards("fade")

func _on_start_game_pressed() -> void:
	animation_player.play("fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/scenes/game_main.tscn")
