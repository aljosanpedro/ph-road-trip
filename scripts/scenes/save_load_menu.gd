extends Control

class_name SaveLoadMenu

enum ContextualType {SAVING, LOADING}

@export_category("Setup")
@export var current_context: ContextualType = ContextualType.SAVING

@onready var overwrite_layer: Control = $OverwriteLayer
@onready var overlay_stopper: ColorRect = $OverwriteLayer/OverlayStopper
@onready var menu_title_label: Label = $PauseMenuItems/SaveLoadMenuLabel

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var slot_children: Array[Node]
var pending_slot_name: String = ""
var pending_slot_ref: SaveSlot = null
var _from_title: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	change_context(current_context)
	
	# Get all possible SaveSlot children for the process. Makes everything
	# dynamic.
	slot_children = find_children("SaveSlot*", "SaveSlot")
	_setup_all_save_load_slots()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func show_save_load_menu(context: ContextualType, from_title: bool = false) -> void:
	_from_title = from_title
	change_context(context)
	_refresh_all_slots()
	# Take a screenshot first BEFORE saving.
	if context == ContextualType.SAVING:
		Dialogic.Save.take_thumbnail()
	show_menu()

func change_context(context: ContextualType) -> void:
	current_context = context #redundant, but needed
	match current_context:
		ContextualType.SAVING:
			menu_title_label.text = "Save"
		ContextualType.LOADING:
			menu_title_label.text = "Load"

func _save_load_slot_pressed(slot_name: String, slot_button_ref: SaveSlot) -> void:
	match current_context:
		ContextualType.SAVING:
			# Save
			if Dialogic.Save.has_slot(slot_name):
				pending_slot_name = slot_name
				pending_slot_ref = slot_button_ref
				_overwrite_layer_show()
			else:
				_perform_save(slot_name, slot_button_ref)

		ContextualType.LOADING:
			if not Dialogic.Save.has_slot(slot_name):
				return
			if _from_title:
				var info = Dialogic.Save.get_slot_info(slot_name)
				Engine.set_meta("pending_load_slot", slot_name)
				Engine.set_meta("pending_game_state", info)
				get_tree().change_scene_to_file("res://scenes/scenes/game_main.tscn")
				Dialogic.Inputs.manual_advance.system_enabled = true
			else:
				var info = Dialogic.Save.get_slot_info(slot_name)
				Dialogic.Save.load(slot_name)
				_restore_game_state(slot_name, info)
				Dialogic.Inputs.manual_advance.system_enabled = true
				hide_menu()


func _perform_save(slot_name: String, slot_button_ref: SaveSlot) -> void:
	var extra_info := {}
	extra_info["date_time"] = Time.get_datetime_string_from_system(false, true)
	extra_info["location"] = _get_current_location()
	extra_info["current_pov"] = Events.current_pov
	extra_info["switches"] = Events.switches.duplicate()
	extra_info["current_scene_path"] = Events.current_scene_path
	_save_scrapbook_pictures(slot_name)
	extra_info["scrapbook_count"] = len(Events.scrapbook_pictures)
	Dialogic.Save.save(slot_name, false, Dialogic.Save.ThumbnailMode.STORE_ONLY, extra_info)

	# Then update the node.
	var filled = Dialogic.Save.has_slot(slot_name)
	var thumbnail = Dialogic.Save.get_slot_thumbnail(slot_name) if filled else null
	var info = Dialogic.Save.get_slot_info(slot_name) if filled else {}
	slot_button_ref.setup(slot_name, thumbnail, info)


func _get_current_location() -> String:
	if Dialogic.current_timeline == null:
		return ""
	var identifier := Dialogic.current_timeline.get_identifier()
	if LocationNames.NAMES.has(identifier):
		return LocationNames.NAMES[identifier]
	return identifier

## If type == true, then we are loading
## else, we are saving.
func _setup_all_save_load_slots() -> void:
	# Setup naming conventions first or whatever.
	for i in len(slot_children):
		var slot_name = "Slot " + str(i + 1)
		
		# Naming and connection
		slot_children[i].name = "Slot" + str(i + 1) # For internal debugging only
		slot_children[i].slot_name = slot_name
		slot_children[i].slot_pressed.connect(_save_load_slot_pressed)
		slot_children[i].delete_pressed.connect(_on_delete_slot_pressed)

func _refresh_all_slots() -> void:
	for slot in slot_children:
		slot.is_loading = (current_context == ContextualType.LOADING)
		var filled = Dialogic.Save.has_slot(slot.slot_name)
		var thumbnail = Dialogic.Save.get_slot_thumbnail(slot.slot_name) if filled else null
		var info = Dialogic.Save.get_slot_info(slot.slot_name) if filled else {}
		slot.setup(slot.slot_name, thumbnail, info)

func _on_back_to_menu_button_pressed() -> void:
	hide_menu()

func _on_delete_slot_pressed(slot_name: String) -> void:
	Dialogic.Save.delete_slot(slot_name)
	_refresh_all_slots()

#region Game State Save/Load

func _save_scrapbook_pictures(slot_name: String) -> void:
	var slot_path = Dialogic.Save.get_slot_path(slot_name)
	for i in len(Events.scrapbook_pictures):
		var tex_rect: TextureRect = Events.scrapbook_pictures[i]
		if tex_rect.texture is ImageTexture:
			var img: Image = tex_rect.texture.get_image()
			img.save_png(slot_path.path_join("scrapbook_%d.png" % i))

func _restore_game_state(slot_name: String, info: Dictionary) -> void:
	if info.is_empty():
		return
	# Restore POV.
	if info.has("current_pov"):
		Events.current_pov = info["current_pov"]
		Events.pov_switch.emit()
	# Restore switches.
	if info.has("switches"):
		var saved_switches: Dictionary = info["switches"]
		for key in saved_switches:
			Events.switches[key] = saved_switches[key]
		Events.switch_has_been_set.emit()
	# Restore current scene path and load the location.
	if info.has("current_scene_path") and info["current_scene_path"] != "":
		Events.change_area(info["current_scene_path"])
	# Restore scrapbook pictures.
	_load_scrapbook_pictures(slot_name, info.get("scrapbook_count", 0))

func _load_scrapbook_pictures(slot_name: String, count: int) -> void:
	Events.scrapbook_pictures = []
	if count == 0:
		return
	var slot_path = Dialogic.Save.get_slot_path(slot_name)
	for i in count:
		var img_path = slot_path.path_join("scrapbook_%d.png" % i)
		if FileAccess.file_exists(img_path):
			var img = Image.load_from_file(img_path)
			var tex_rect = TextureRect.new()
			tex_rect.texture = ImageTexture.create_from_image(img)
			tex_rect.custom_minimum_size = Vector2(200, 181)
			tex_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
			tex_rect.scale = Vector2(0.18, 0.17)
			tex_rect.position.x += 1.9
			tex_rect.position.y += 1.5
			Events.scrapbook_pictures.append(tex_rect)

#endregion

#region Overwriting Save Logic

func _overwrite_layer_show() -> void:
	overwrite_layer.visible = true

func _overwrite_layer_hide() -> void:
	overwrite_layer.visible = false
	pending_slot_name = ""
	pending_slot_ref = null

func _on_overlay_stopper_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		_overwrite_layer_hide()

func _on_overwrite_no_pressed() -> void:
	_overwrite_layer_hide()

func _on_overwrite_yes_pressed() -> void:
	if pending_slot_ref:
		_perform_save(pending_slot_name, pending_slot_ref)
	_overwrite_layer_hide()

#endregion

func show_menu() -> void:
	animation_player.play("show_menu")

func hide_menu() -> void:
	animation_player.play_backwards("show_menu")

func _on_return_button_pressed() -> void:
	animation_player.play_backwards("show_menu")
