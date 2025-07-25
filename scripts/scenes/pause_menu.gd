@icon("res://nodes/pause_menu.svg")

class_name PauseMenu
extends Control

@export_category("Initialization Details")
@export var if_title_screen: bool = false

@onready var play_button: Button = $PlayButton
@onready var pause_button: Button = $PauseButton
@onready var pause_menu_items: Control = $PauseMenuItems

@onready var pause_menu_label: Label = $PauseMenuItems/PauseMenuLabel
@onready var to_title_screen_button: Button = $PauseMenuItems/ButtonList/ToTitleScreenButton
@onready var quit_button: Button = $PauseMenuItems/ButtonList/QuitButton
@onready var return_button: Button = $PauseMenuItems/ButtonList/ReturnButton

@onready var music_slider: HSlider = $PauseMenuItems/AudioSettings/MusicVolumeSlider
@onready var sound_slider: HSlider = $PauseMenuItems/AudioSettings/SoundVolumeSlider
@onready var sfx_slider: HSlider = $PauseMenuItems/AudioSettings/SFXVolumeSlider

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	music_slider.value = GameSettings.music_volume
	sound_slider.value = GameSettings.sound_volume
	sfx_slider.value = GameSettings.sfx_volume
	
	if if_title_screen:
		pause_menu_label.text = "Settings"
		
		play_button.hide()
		pause_button.hide()
		pause_menu_items.hide()
		
		to_title_screen_button.hide()
		quit_button.hide()
	else:
		return_button.hide()
		
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


#region Audio Management

func _on_music_volume_slider_value_changed(value: float) -> void:
	print(value)
	GameSettings.music_volume_change(value)

func _on_sound_volume_slider_value_changed(value: float) -> void:
	print(value)
	GameSettings.sound_volume_change(value)

func _on_sfx_volume_slider_value_changed(value: float) -> void:
	GameSettings.sfx_volume_change(value)
	
#endregion

func _on_to_title_screen_button_pressed() -> void:
	Events.reset()
	Dialogic.end_timeline()
	
	await Events.wait(1)
	
	get_tree().change_scene_to_file("res://scenes/scenes/title_screen.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

#region Title screen only function

## For title screen only.
func _on_return_button_pressed() -> void:
	if animation_player.is_playing(): return
	
	animation_player.play_backwards("show_menu")
	await animation_player.animation_finished

	pause_menu_items.hide()
	pause_menu_items.mouse_filter = Control.MOUSE_FILTER_IGNORE

func show_settings() -> void:
	if animation_player.is_playing(): return
	
	# Compared to previous ones above, have to trigger this immediately.
	pause_menu_items.mouse_filter = Control.MOUSE_FILTER_STOP
	
	pause_menu_items.show()

	animation_player.play("show_menu")
	await animation_player.animation_finished
	

#endregion
