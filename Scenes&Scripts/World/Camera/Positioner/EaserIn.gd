extends Positioner
class_name EaserIn


signal destination_reached

@export var rapidity : float = 20
var start_time : float = 2
var _time : float = start_time



func get_desired_position(prev_position : Vector2, delta : float) -> Vector2:
	if target.global_position.is_equal_approx(prev_position):
		_time = start_time
		destination_reached.emit()
		print("Easer in dest reached")
	_time += delta
	var speed = pow(rapidity, _time)
	print("Easer in running")
	return target.global_position.move_toward(prev_position, delta * speed)