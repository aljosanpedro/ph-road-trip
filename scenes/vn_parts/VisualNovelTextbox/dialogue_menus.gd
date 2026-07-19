extends HBoxContainer

@onready var auto_skip_button: TextureButton = $AutoSkipButton
@onready var auto_play_button: TextureButton = $AutoPlayButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.Inputs.auto_skip.toggled.connect(_on_auto_skip_toggled)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_key_input(event: InputEvent) -> void:
	print("Dialogue Menus Event captured:", event)

func _on_auto_skip_toggled(is_enabled: bool) -> void:
	pass

func _on_settings_button_pressed() -> void:
	pass # Replace with function body.

func _on_save_load_button_pressed() -> void:
	pass # Replace with function body.

func _on_menu_button_pressed() -> void:
	Events.show_pause_menu(true)

func _on_history_button_pressed() -> void:
	Events.show_history(true)

func _on_auto_play_button_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.

func _on_auto_skip_button_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.
