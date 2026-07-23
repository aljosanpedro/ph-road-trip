extends Panel

class_name CustomTooltip

var text_label: Label

func set_text(value: String) -> void:
	text_label = $MarginContainer/Label
	text_label.text = value

func _ready() -> void:
	text_label = $MarginContainer/Label
	text_label.add_theme_color_override("font_color", Color(0.15, 0.15, 0.15))
	
	custom_minimum_size  = $MarginContainer.get_minimum_size()

func _get_minimum_size() -> Vector2:
	return $MarginContainer.get_minimum_size()
