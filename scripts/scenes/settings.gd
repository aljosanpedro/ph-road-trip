# CanvasLayers.layer
	# Screen (2) > "Gameplay" (1)
	# Button (3) > Screen (2)


extends Control


enum PopupButtons { TITLE, QUIT }

@export var title_screen : PackedScene

@onready var popup : Popup = $Button/MenuButton.get_popup()
@onready var screen : Node = $Screen


# MenuButton
func _ready() -> void:
	# Access popup items when menubutton is pressed
		# Hidden function id_pressed -> item id : int
	popup.connect("id_pressed", _on_item_pressed)


func _on_item_pressed(id) -> void:
	match id:
		PopupButtons.TITLE:
			Events.reset()
			get_tree().change_scene_to_packed(title_screen)
			
		PopupButtons.QUIT:
			get_tree().quit()


# Pause
func _on_button_toggled(toggled_on: bool) -> void:
	get_tree().paused = toggled_on
	screen.visible = toggled_on
	
	if toggled_on:
		mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
