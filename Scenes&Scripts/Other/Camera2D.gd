extends Camera2D


## Where the camera should try to position itself along the line between the player and the cursor.
## 0 is at the player and 1 is at the cursor.
@export_range(0,1, 0.1) var cam_center_ratio : float = 0.2

## The position the camera will try to be at.
var desired_position : Vector2


func _physics_process(delta) -> void:
	if GlobalReferences.playerExists:
		desired_position = GlobalReferences.player.position + (get_global_mouse_position() - GlobalReferences.player.position) * cam_center_ratio
	
	var dist := (desired_position - position).length()
	position = position.move_toward(desired_position, max(15*dist * delta, 2))

