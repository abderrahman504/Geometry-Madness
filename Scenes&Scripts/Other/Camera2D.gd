extends Camera2D



func _process(_delta):
	if GlobalReferences.playerExists:
		position = GlobalReferences.player.position + (get_global_mouse_position() - GlobalReferences.player.position) * 0.3
