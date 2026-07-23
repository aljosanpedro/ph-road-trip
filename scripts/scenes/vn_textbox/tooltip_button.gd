extends TextureButton

func _make_custom_tooltip(for_text: String) -> Control:
	var tooltip = preload("res://scenes/components/custom_tooltip.tscn").instantiate() as CustomTooltip
	tooltip.set_text(for_text)
	return tooltip
