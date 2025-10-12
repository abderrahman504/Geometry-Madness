extends Camera2D


@export_range(0,1, 0.1) var cam_center_ratio : float = 0.2


func _physics_process(_delta):
	if GlobalReferences.playerExists:
		position = GlobalReferences.player.position + (get_global_mouse_position() - GlobalReferences.player.position) * cam_center_ratio
