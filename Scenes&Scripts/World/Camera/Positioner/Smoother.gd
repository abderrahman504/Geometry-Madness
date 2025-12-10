extends Positioner
class_name Smoother

## Interpolates between the target's current position and the input position.

@export var rapidity : float = 15

func get_desired_position(prev_position : Vector2, delta : float) -> Vector2:
	var dist := (prev_position - target.position).length()
	return target.position.move_toward(prev_position, max(delta * rapidity * dist, 2))
