extends Positioner
class_name EaserIn


signal destination_reached

@export var rapidity : float = 20
## Specifies how much time the easing function should assume has passed since it started.
var start_time : float = 2
var _time : float = start_time



func get_desired_position(prev_position : Vector2, delta : float) -> Vector2:
	_time += delta
	var speed = pow(rapidity, _time)
	var out := target.global_position.move_toward(prev_position, delta * speed)
	if target.global_position.distance_to(prev_position) <= speed * delta:
		_time = start_time
		destination_reached.emit()
	return out