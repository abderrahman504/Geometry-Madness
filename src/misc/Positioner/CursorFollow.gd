extends Positioner
class_name CursorFollow

## Positions the target somewhere between the player and the cursor.


## 0 is at the player and 1 is at the cursor.
@export_range(0,1, 0.1) var follow_ratio : float = 0.2


var desired_pos : Vector2

func _physics_process(_delta) -> void:
	if GlobalReferences.playerExists:
		desired_pos = GlobalReferences.player.position + (target.get_global_mouse_position() - GlobalReferences.player.position) * follow_ratio



func get_desired_position(_prev_position : Vector2, _delta : float) -> Vector2:
	return desired_pos

