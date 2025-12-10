extends Node
class_name Positioner

## Base class for positioner nodes. Positioner nodes contain logic to set the position of a target.

## The target node.
var target : Node2D



## Called on every positioner in the chain.
## [code]position[/code] is either the output of the previous positioner in the chain, 
## or the position of the target in case of the first positioner.
func get_desired_position(prev_position : Vector2, _delta : float) -> Vector2:
	return prev_position


