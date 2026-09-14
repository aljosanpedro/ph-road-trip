@icon("res://nodes/event_interactable.svg")

#==============================================================================
class_name InteractableEvent
extends MapEventBase
#------------------------------------------------------------------------------
# This class handles interactable events in the map.
#==============================================================================

#region Initialized Variables and Exports
@export_category("Required")
## The Hitbox for the component.
@export var hitbox_component: CollisionShape2D
## The Sprite2D component required for the object.
@export var sprite_component: Sprite2D
## Item base checks which character can only interact with it. 
## Default: Both can interact with it.
@export var required_character: Events.POV_Character = Events.POV_Character.BOTH
## A simple check that indicates if the item is instead a character.
## No need for additional changes. Just make sure that the different
## required character is the opposite. i.e. RC = Wiks => Adi Interactable.
@export var is_character_interactable: bool = false
#endregion	

#region Virtual functions
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	# Connect callable.
	Events.pov_switch.connect(_pov_switch_grayout)
	Events.set_item_outline.connect(_show_item_outline)
	
	# Call for the first time.
	_pov_switch_grayout()
	
	# However, check if it turns out they need to be removed from existence when
	# scene starts.
	if is_character_interactable:
		hide()

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if not _required_character_checker():
		get_viewport().set_input_as_handled()
		return
	
	if event.is_action_pressed("mouse_click"):
		print("You clicked " + name + "!")
		
		# Call interact.
		interact()
		
		# Set as handled.
		get_viewport().set_input_as_handled()

#endregion

#region Interactable/Character functions

## INFO: Highlights item when mouse hovers to the item.
func _on_mouse_entered() -> void:
	if not _required_character_checker(): return
	if sprite_component != null: sprite_component.set_use_parent_material(true)  # Show outline.
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	#modulate = Color(2, 2, 2)

## INFO: De-highlights item when mouse hovers away from the item.
func _on_mouse_exited() -> void:
	if not _required_character_checker(): return
	if sprite_component != null: sprite_component.set_use_parent_material(false) # Hide outline.
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	#modulate = Color(1, 1, 1)
	
## INFO: Checks for the current character POV. [b]Returns true[/b] if its the 
## character we want, [b]returns false[/b] otherwise.
func _required_character_checker() -> bool:
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
	if not _required_character_checker():
		if sprite_component != null: sprite_component.set_use_parent_material(false)
		#modulate = Color(0.5, 0.5, 0.5)
		
		# If current character, and is character interactable, REMOVE
		if is_character_interactable: hide()
	else:
		#if sprite_component != null: sprite_component.set_use_parent_material(true)
		#modulate = Color(1, 1, 1)
		
		# If not current character, and is character interactable, SHOW
		if is_character_interactable: show()

## INFO: Shows/hides item outline when called.
func _show_item_outline(value: bool) -> void:
	## If true, do POV switchout as normal.
	if value == true:
		_pov_switch_grayout()
		set_pickable(true)
		
	# If not, then modulate and stuff. And DISALLOW any mouse enter/exits.
	else:
		#if sprite_component != null: sprite_component.set_use_parent_material(false)
		modulate = Color(1, 1, 1)
		set_pickable(false)
#endregion
