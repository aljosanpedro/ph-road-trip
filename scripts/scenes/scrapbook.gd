extends Control


@onready var entries : Control = $Entries
@onready var locations : Array[Node] = entries.get_children(false)
	# include_internal = false; no children

var pictures = Events.scrapbook_pictures


func _ready() -> void:
	for i in range(len(pictures)):
		var location : String = locations[i].name
		var frame : Node = get_node("Entries/" + location + "/Polaroid/Frame")
		
		var picture : Node = pictures[i]
		
		frame.add_child(picture)
