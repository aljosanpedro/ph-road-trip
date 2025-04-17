extends Control

#region Initialized Variables and Exports
@onready var adi_button_picture = $AdiButton
@onready var wiks_button_picture = $WiksButton
#endregion

#region Virtual functions
func _ready() -> void:
	# INFO: Connect Events signal busses.
	Events.enable_character_povs.connect(_enable_character_povs)
	
	# INFO: Start entire POV switching after New Game.
	initialize()

## Initializes Events for a new game.
func initialize() -> void:
	_switch_character_pov(Events.get_current_pov())

## INFO: When the Adi graphic is pressed.
func _on_adi_button_pressed() -> void:
	_switch_character_pov(Events.POV_Character.ADI)
	
## INFO: When the Wiks graphic is pressed.
func _on_wiks_button_pressed() -> void:
	_switch_character_pov(Events.POV_Character.WIKS)

#endregion

#region Custom Functions
## Switches character [param POV] graphically.
func _switch_character_pov(new_pov: Events.POV_Character) -> void:
	# Set graphical changes first.
	match new_pov:
		Events.POV_Character.ADI:
			adi_button_picture.modulate = Color(1,1,1)
			wiks_button_picture.modulate = Color(0.5,0.5,0.5)
		Events.POV_Character.WIKS:
			wiks_button_picture.modulate = Color(1,1,1)
			adi_button_picture.modulate = Color(0.5,0.5,0.5)
	
	# Then, change POV based on new_pov.
	Events.set_current_pov(new_pov)

## This is for the 4th act. Checks who your current POV is.
func _enable_character_povs(value: bool) -> void:
	# If True, enable Character POV switching again.
	if value:
		adi_button_picture.disabled = false
		wiks_button_picture.disabled = false
	
	# If False, disable specific POV Switching for non-focused character.
	else:
		match Events.get_current_pov():
			Events.POV_Character.ADI:
				adi_button_picture.disabled = true
			Events.POV_Character.WIKS:
				wiks_button_picture.disabled = true
		
#endregion
