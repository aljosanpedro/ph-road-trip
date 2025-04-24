extends Area2D
## ItemBase is the base of an item that can be interacted in the map.
## Has a signal `item_clicked` that allows more control on the map.
##
## Requires:
## Sprite2D to manipulate
## CollisionShape2D for it to directly reference the shape.

#region Initialized Variables and Exports
@export_group("Required")
## The Hitbox for the component.
@export var hitbox_component: CollisionShape2D
## The Sprite2D component required for the object.
@export var sprite_component: Sprite2D
## Item base checks which character can only interact with it. 
## Default: Both can interact with it.
@export var required_character: Events.POV_Character = Events.POV_Character.BOTH

## Required in order to interact with the map instead of having its own separate
## standalones.
signal item_clicked()
#endregion	

#region Virtual functions
func _ready() -> void:
	# Connect callable.
	Events.pov_switch.connect(_pov_switch_grayout)
	# Call for the first time.
	_pov_switch_grayout()

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if _pov_checker(): return
	
	if event.is_action_pressed("mouse_click"):
		print("You clicked " + name + "!")
		item_clicked.emit()

## INFO: Highlights item when mouse hovers to the item.
func _on_mouse_entered() -> void:
	if _pov_checker(): return
	
	modulate = Color(2, 2, 2)

## INFO: De-highlights item when mouse hovers away from the item.
func _on_mouse_exited() -> void:
	if _pov_checker(): return
	
	modulate = Color(1, 1, 1)
	
## INFO: Checks for the current character POV.
func _pov_checker() -> bool:
	# Check first if both POVs are allowed.
	if required_character != Events.POV_Character.BOTH:
	# If not the required character, do not allow at all.
		if Events.get_current_pov() != required_character:
			return false
			
	# Return true if all checks are done.
	return true

## INFO: Function that graphically changes saturation when switching POVs.
## Allows for better info.
func _pov_switch_grayout() -> void:
	if _pov_checker():
		modulate = Color(0.5, 0.5, 0.5)
	else:
		modulate = Color(1, 1, 1)
		
#endregion
