extends Positioner
class_name Shaker

## Shakes the target when triggered via [code]shake()[/code]

## The strength of the shake
var shake_strength : float = 1

## The direction of the shake
var shake_direction : Vector2 = Vector2.RIGHT

## How long the shake will last
@export var duration : float = 2
## Tha maximum distance the target is offset from it's origin.
@export var dist : float = 15

@onready var _timer : float = duration + 1


func get_desired_position(prev_position : Vector2, _delta: float) -> Vector2:
	var shake_vec := shake_func2(min(_timer, duration)) * shake_direction
	return prev_position + shake_vec


func _process(delta : float) -> void:
	if _timer <= duration:
		_timer += delta


func shake(strength : float, direction : Vector2) -> void:
	print("shaking")
	_timer = 0
	self.shake_strength = strength
	self.shake_direction = direction


func shake_func(time : float) -> float:
	return dist * sin(time * 2*PI*shake_strength / duration) * max(duration - time, 0) / duration 


func shake_func2(time : float) -> float:
	return dist * sin(time * 2*PI * 5) * max(duration - time, 0)