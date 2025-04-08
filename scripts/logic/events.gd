extends Node

signal change_map(path: String)

#region Virtual functions
func _ready() -> void:
	pass
#endregion


#region Custom Functions
## Changes area to the PackedScene [param path].
## Pretty much a helper function for a signal to make code readable.
func change_area(path: String) -> void:
	change_map.emit(path)
#endregion
