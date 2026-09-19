@icon("res://nodes/command_animation.svg")

class_name AnimationPlayerCommand
extends Commands

## Node to get reference about animation player. Must be in string form.
## Also, must target the sibling.
@export var animation_player: String
## String to play from animation player.
@export var animation_string: String

@warning_ignore("unused_parameter")
func execute(node: MapEventBase) -> bool:
	var actual_player: AnimationPlayer = node.get_parent().get_node(animation_player)
	actual_player.play(animation_string)
	await actual_player.animation_finished
	
	return true
