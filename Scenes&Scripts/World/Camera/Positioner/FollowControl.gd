extends Positioner
class_name FollowControl

@export var followed : Control


func get_desired_position(prev_position : Vector2, delta : float) -> Vector2:
	var followed_pos_in_viewport = followed.get_global_transform_with_canvas().origin
	var target_pos_in_viewport = target.get_global_transform_with_canvas().origin
	var relative_pos = followed_pos_in_viewport - target_pos_in_viewport
	var followed_global_pos = target.global_position + relative_pos
	#print("Control position = ", followed.get_global_transform_with_canvas().origin)
	return followed_global_pos + 0.5 * followed.size
