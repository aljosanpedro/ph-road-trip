extends Node

# This is all index based!

enum SWCH_NAME {
	LOC_1_STALL,
	LOC_1_SUNKEN_GARDEN,
	LOC_1_ADIS_MURAL,
	LOC_1_TREES,
	LOC_1_LOOSE_CHICKEN,
	LOC_2_KIDS_PLAYING,
	LOC_2_LANTERNS,
	LOC_2_RADIO,
	LOC_2_GRAFFITI,
	LOC_2_CLOTHES,
	LOC_2_MANNEQUINS,
	LOC_2_JABEE
}

enum VAR_NAME {
	VAR_1,
	VAR_2,
}

var switches: Dictionary[SWCH_NAME, bool] = {}
var variables: Dictionary[VAR_NAME, Variant] = {}

## Initializes everything.
func _init() -> void:
	# Initialize switches
	for id in SWCH_NAME.values():
		switches[id] = false
	
	# Initialize variables
	for id in VAR_NAME.values():
		variables[id] = false
	
	print(switches)
	print(variables)

## Get the value of a switch.
func get_switch(id: SWCH_NAME) -> bool:
	return switches.get(id, false)

## Set up the boolean for a switch.
func set_switch(id: SWCH_NAME, value: bool) -> void:
	# Return if we're just going to do the same thing.
	if switches.get(id, false) == value: return
	
	# Set switch.
	switches[id] = value

## Get the value of a variable.
func get_variable(id: VAR_NAME) -> Variant:
	return variables.get(id, 0)

## Get the value of a variable.
func set_variable(id: VAR_NAME, value: Variant) -> void:
	# Return if we're just going to do the same thing.
	if variables.get(id, false) == value: return
	
	# Set switch.
	variables[id] = value
