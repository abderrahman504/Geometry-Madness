extends Positioner
class_name FollowNode

@export var followed : Node2D


func get_desired_position(prev_position : Vector2, delta : float) -> Vector2:
	return followed.global_position
