extends Node

# Values
@onready var master_volume: float
@onready var fullscreen_value: bool
@onready var music_volume: float
@onready var sfx_volume: float
@onready var game_cleared: bool

func _ready():
	_load_settings()
	
	master_volume_change(master_volume)
	music_volume_change(music_volume)
	sfx_volume_change(sfx_volume)
	fullscreen_change(fullscreen_value)

func master_volume_change(volume: float):
	master_volume = volume
	
	AudioServer.set_bus_volume_db(0, linear_to_db(master_volume))

func music_volume_change(volume: float):
	music_volume = volume
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"),linear_to_db(music_volume))

func sfx_volume_change(volume: float):
	sfx_volume = volume
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),linear_to_db(sfx_volume))

func fullscreen_change(value: bool):
	fullscreen_value = value
	
	if fullscreen_value:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			
func _default_settings():
	master_volume = 1.0
	music_volume = 1.0
	sfx_volume = 1.0
	fullscreen_value = true
	game_cleared = false

func _load_settings():
	# Creates new ConfigFile object
	var config = ConfigFile.new()
	
	# Loads settings with errors in mind.
	var err = config.load("user://settings.cfg")
	
	# If there's no settings, then make some.
	if err != OK:
		_default_settings()
		_save_settings()
		return

	# If not, well, we're getting values. (No need to close, Godot does its job)
	master_volume = config.get_value("Music", "master_volume")
	music_volume = config.get_value("Music", "music_volume")
	sfx_volume = config.get_value("Music", "sfx_volume")
	fullscreen_value = config.get_value("Window", "window_mode")

func _save_settings():
	# Creates new ConfigFile object.
	var config = ConfigFile.new()
	
	# Stores some values.
	config.set_value("Music", "master_volume", master_volume)
	config.set_value("Music", "music_volume", music_volume)
	config.set_value("Music", "sfx_volume", sfx_volume)
	config.set_value("Window", "window_mode", fullscreen_value)
	
	config.set_value("Game", "cleared", game_cleared)

	# It's saving time! (No need to close, Godot already does the job for us)
	config.save("user://settings.cfg")

## Created under the assumption that we have made settings beforehand.
func check_if_cleared():
	var config = ConfigFile.new()
	var _err = config.load("user://settings.cfg")
	
	# Creation means that it is the player's first time.
	if config.get_value("Game", "cleared") == true:
		return true
	else:
		game_cleared = true
		_save_settings()
		return false
		
