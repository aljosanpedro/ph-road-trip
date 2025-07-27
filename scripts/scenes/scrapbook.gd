extends Control

@onready var fade_texture = $Fade
@onready var entries = $Entries

@onready var anim_player: AnimationPlayer = $AnimationPlayer

const FADE_DURATION : float = 1.5


func _ready() -> void:
	AudioManager.bgm_play("res://assets/audio/bgm/shell.mp3")
	set_entries()
	
	anim_player.play("fade")
	


func set_entries() -> void:
	var entries_children : Array[Node] = entries.get_children(false)
		# Node: Node2D
		# include_internal = false; no children

	var pictures : Array[Node] = Events.scrapbook_pictures
		# Node: TextureRect
	
	for i in range(len(pictures)):
		var entry : String = entries_children[i].name
		var picture : Node = pictures[i]
		
		set_photo(entry, picture)
		set_label(entry)


func set_photo(entry, picture) -> void:
	var frame : Node = get_node("Entries/" + entry + "/Polaroid/Frame")
	
	frame.add_child(picture)


func set_label(entry) -> void:
	var label : Node = get_node("Entries/" + entry + "/Polaroid/Frame/Label")
		
	label.text = entry


func _on_to_title_screen_button_pressed() -> void:
	Events.reset()

	anim_player.play_backwards("fade")

	await anim_player.animation_finished	
	
	get_tree().change_scene_to_file("res://scenes/scenes/title_screen.tscn")
