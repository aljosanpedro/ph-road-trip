extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_settings_button_pressed() -> void:
	pass # Replace with function body.

func _on_save_load_button_pressed() -> void:
	pass # Replace with function body.

func _on_menu_button_pressed() -> void:
	Events.show_pause_menu(true)

func _on_history_button_pressed() -> void:
	Events.show_history(true)
