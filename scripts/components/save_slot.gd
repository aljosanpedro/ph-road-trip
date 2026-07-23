extends Button

class_name SaveSlot
signal slot_pressed(slot_name: String, slot_button_ref: SaveSlot)
signal delete_pressed(slot_name: String)

@export var slot_name: String = ""
@export var frame_hover_modulate: Color = Color("#00d5d9")

@onready var thumbnail: TextureRect = $ThumbnailArea/Thumbnail
@onready var frame: TextureRect = $ThumbnailArea/Frame
@onready var empty_overlay: ColorRect = $ThumbnailArea/EmptyOverlay
@onready var empty_label: Label = $ThumbnailArea/EmptyOverlay/EmptyLabel
@onready var info_container_color: ColorRect = $InfoContainerColor
@onready var slot_name_label: Label = $SlotNameLabel
@onready var location_label: Label = $InfoContainer/LocationLabel
@onready var date_time_label: Label = $InfoContainer/DateTimeLabel
@onready var delete_button: TextureButton = $DeleteButton

var is_empty: bool = true
var is_loading: bool = false

func _ready() -> void:
	_update_display()

func setup(p_slot_name: String, p_thumbnail: ImageTexture = null, p_info: Dictionary = {}) -> void:
	slot_name = p_slot_name
	is_empty = p_thumbnail == null

	if p_thumbnail:
		thumbnail.texture = p_thumbnail
	else:
		thumbnail.texture = null

	slot_name_label.text = p_slot_name

	if p_info.has("location") and not p_info["location"].is_empty():
		location_label.text = p_info["location"]
	else:
		location_label.text = ""

	if p_info.has("date_time"):
		date_time_label.text = p_info["date_time"]
	else:
		date_time_label.text = ""

	_update_display()

func _update_display() -> void:
	if not is_node_ready():
		return

	empty_overlay.visible = is_empty
	info_container_color.visible = not is_empty
	thumbnail.visible = not is_empty
	slot_name_label.visible = not is_empty
	location_label.visible = not is_empty and not location_label.text.is_empty()
	date_time_label.visible = not is_empty
	delete_button.visible = not is_empty

func _on_pressed() -> void:
	slot_pressed.emit(slot_name, self)

func _on_mouse_entered() -> void:
	if is_empty and is_loading:
		return
	frame.modulate = frame_hover_modulate

func _on_mouse_exited() -> void:
	frame.modulate = Color.WHITE

func _on_delete_pressed() -> void:
	delete_pressed.emit(slot_name)

func _on_delete_button_mouse_entered() -> void:
	delete_button.modulate = Color(0.7, 0.7, 0.7)

func _on_delete_button_mouse_exited() -> void:
	delete_button.modulate = Color.WHITE
