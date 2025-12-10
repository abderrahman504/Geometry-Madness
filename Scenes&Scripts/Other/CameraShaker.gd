extends Node
class_name CameraShaker


@export var shake : bool:
	set(val):
		if val:
			shake_camera(shake_strength, shake_direction)

@export var shake_strength : float = 1
@export var shake_direction : Vector2 = Vector2.RIGHT

func shake_camera(strength : float, direction : Vector2) -> void:
	pass