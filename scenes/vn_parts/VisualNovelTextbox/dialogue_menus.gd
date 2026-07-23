extends HBoxContainer

@onready var auto_skip_button: TextureButton = $AutoSkipButton
@onready var auto_play_button: TextureButton = $AutoPlayButton

# Early instantiation.
func _init() -> void:
	Dialogic.Inputs.auto_skip.toggled.connect(_on_auto_skip_toggled)
	Dialogic.Inputs.auto_advance.toggled.connect(_on_autoadvance_toggled)
	Events.shortcut_save_pressed.connect(_on_save_button_pressed)
	Events.shortcut_load_pressed.connect(_on_load_button_pressed)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Dialogic.Inputs.auto_advance.is_enabled(): auto_play_button.set_pressed_no_signal(true)
	if Dialogic.Inputs.auto_skip.enabled: auto_skip_button.set_pressed_no_signal(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_key_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("dialogic_auto_advance_action"):
		# Hacky way to act like a button is pressed.
		auto_play_button.button_pressed = !auto_play_button.button_pressed
		
	if Input.is_action_just_pressed("dialogic_auto_skip_button"):
		auto_skip_button.button_pressed = !auto_skip_button.button_pressed
		
	if Input.is_action_just_pressed("dialogic_history_button"):
		_on_history_button_pressed()

#region Dialogic connections

## Connection to Dialogic's nonsense.
## Changes only graphically.
func _on_auto_skip_toggled(enabled: bool) -> void:
	auto_skip_button.button_pressed = enabled
	#auto_skip_button.button_pressed = is_enabled
	
func _on_autoadvance_toggled(enabled: bool) -> void:
	auto_play_button.button_pressed = enabled
	
#endregion


func _on_settings_button_pressed() -> void:
	pass # Replace with function body.


func _on_save_button_pressed() -> void:
	Events.show_save_menu()

func _on_load_button_pressed() -> void:
	Events.show_load_menu()


func _on_menu_button_pressed() -> void:
	Events.show_pause_menu(true)

func _on_history_button_pressed() -> void:
	Events.show_history(true)

func _on_auto_play_button_toggled(toggled_on: bool) -> void:
	print("being toggled", toggled_on)
	Dialogic.Inputs.auto_advance.enabled_until_user_input = toggled_on

func _on_auto_skip_button_toggled(toggled_on: bool) -> void:
	print("being skipped", toggled_on)
	Dialogic.Inputs.auto_skip.enabled = toggled_on
