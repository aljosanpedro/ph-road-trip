extends Area2D
## ItemBase is the base of an item that can be interacted in the map.
## Has a signal `item_clicked` that allows more control on the map.
##
## Requires:
## Sprite2D to manipulate
## CollisionShape2D for it to directly reference the shape.

#region Initialized Variables and Exports
@export_group("Required")
@export var hitbox_component: CollisionShape2D
@export var sprite_component: Sprite2D

## Required in order to interact with the map instead of having its own separate
## standalones.
signal item_clicked()
#endregion	

#region Virtual functions
func _ready() -> void:
	pass

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("mouse_click"):
		print("You clicked " + name + "!")
		item_clicked.emit()

## INFO: Highlights item when mouse hovers to the item.
func _on_mouse_entered() -> void:
	modulate = Color(2, 2, 2)

## INFO: De-highlights item when mouse hovers away from the item.
func _on_mouse_exited() -> void:
	modulate = Color(1, 1, 1)

#endregion
