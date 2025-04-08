extends Node


func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/scenes/game_main.tscn")
