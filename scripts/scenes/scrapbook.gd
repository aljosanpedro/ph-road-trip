extends Control

@onready var fade_texture = $Fade
@onready var entries = $Entries

const FADE_DURATION : float = 1.5


func _ready() -> void:
	fade_in()
	set_entries()


func fade_in() -> void:
	fade_texture.visible = true
	
	var tween = get_tree().create_tween()
	
	tween.tween_property(fade_texture, "color", Color.TRANSPARENT, FADE_DURATION)


func set_entries() -> void:
	var entries : Array[Node] = entries.get_children(false)
		# Node: Node2D
		# include_internal = false; no children

	var pictures : Array[Node] = Events.scrapbook_pictures
		# Node: TextureRect
	
	for i in range(len(pictures)):
		var entry : String = entries[i].name
		var picture : Node = pictures[i]
		
		set_photo(entry, picture)
		set_label(entry)


func set_photo(entry, picture) -> void:
	var frame : Node = get_node("Entries/" + entry + "/Polaroid/Frame")
	
	frame.add_child(picture)


func set_label(entry) -> void:
	var label : Node = get_node("Entries/" + entry + "/Polaroid/Frame/Label")
		
	label.text = entry
