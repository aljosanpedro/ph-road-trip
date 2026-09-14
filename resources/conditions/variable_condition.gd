@icon("res://nodes/var_condition.svg")

#==============================================================================
class_name VariableCondition
extends Resource
#------------------------------------------------------------------------------
# A single variable requirement: var_name OP value
# e.g. GOLD >= 100
#==============================================================================

enum COMPARISON {
	EQUAL,
	NOT_EQUAL,
	GREATER,
	GREATER_EQUAL,
	LESS,
	LESS_EQUAL
}

@export var var_name: DataManager.VAR_NAME
@export var comparison: COMPARISON = COMPARISON.EQUAL
@export var value: int

func is_met() -> bool:
	var current: int = DataManager.get_variable(var_name)
	match comparison:
		COMPARISON.EQUAL:
			return current == value
		COMPARISON.NOT_EQUAL:
			return current != value
		COMPARISON.GREATER:
			return current > value
		COMPARISON.GREATER_EQUAL:
			return current >= value
		COMPARISON.LESS:
			return current < value
		COMPARISON.LESS_EQUAL:
			return current <= value
	return false
