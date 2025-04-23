#===============================================================================
# Least insane RPG Maker dickriding
#===============================================================================
extends Node

@onready var background_music = %BGM
@onready var background_sound = %BGS
@onready var sound_effect_queue = $SFX


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

#region BGM
## Plays BGM. Replaces if BGM currently playing.
func bgm_play(path: String, volume: float = 0):
	var new_music = load(path)
	
	# Check if BGM is the same
	if background_music.stream == new_music:
		print("The same music.")
		return
	
	# Switches BGM.
	if background_music.playing:
		bgm_stop()
	
	background_music.stream = load(path)
	background_music.stream.loop = true
	
	background_music.volume_db = volume
	background_music.play()

func bgm_pause(value: bool):
	background_music.stream_paused = value

func bgm_fade(fade: float = 0):
	var tween = get_tree().create_tween()
	tween.tween_property(background_music, "volume_db", -80, fade)
	await tween.finished

## Stops BGM, as expected.
func bgm_stop(fade: float = 0):
	if fade > 0:
		var tween = get_tree().create_tween()
		tween.tween_property(background_music, "volume_db", -80, fade)
		await tween.finished
	
	background_music.stop()
	background_music.volume_db = 0
	background_music.stream = null


#endregion

#region BGS
## Plays BGS. Replaces if BGS currently playing.
func bgs_play(path: String):
	var new_music = load(path)
	
	# Check if BGM is the same
	if background_sound.stream == new_music:
		print("The same music.")
		return
	
	# Switches BGM.
	if background_sound.playing:
		bgs_stop()
	
	background_sound.stream = load(path)
	background_sound.stream.loop = true
	background_sound.play()

## Stops BGS, as expected.
func bgs_stop():
	background_sound.stop()
	background_sound.stream = null

func bgs_volume(volume: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGS"),linear_to_db(volume))
#endregion

#region SFX
func sfx_play(path):
	var sfx = AudioStreamPlayer.new()
	sound_effect_queue.add_child(sfx)
	sfx.finished.connect(_sfx_free.bind(sfx))
	sfx.bus = &"SFX"
	
	#print("Working")
	if path is String:
		sfx.stream = load(path)
	else: 
		sfx.stream = path
	sfx.play()

func sfx_stop_all():
	for sound in sound_effect_queue.get_children():
		sound.stop()
		sound_effect_queue.remove_child(sound)
		sound.queue_free()

func _sfx_free(sfx_node):
	sfx_node.queue_free()
#endregion

func pause_game() -> void:
	sfx_stop_all()
	#bgm_pause(true)
	AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("BGM"), 0, true)

func resume_game() -> void:
	#bgm_pause(false)
	AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("BGM"), 0, false)
