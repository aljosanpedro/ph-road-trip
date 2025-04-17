extends Area2D

#region Initialized Variables and Exports
@export_group("Required")
@export var hitbox_component: CollisionShape2D
@export var sprite_component: Sprite2D

signal item_clicked()
#endregion	

#region Virtual functions
func _ready() -> void:
	pass
	
func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("mouse_click"):
		print("You clicked " + name + "!")
		item_clicked.emit()

func _on_mouse_entered() -> void:
	modulate = Color(2, 2, 2)

func _on_mouse_exited() -> void:
	modulate = Color(1, 1, 1)

#endregion
