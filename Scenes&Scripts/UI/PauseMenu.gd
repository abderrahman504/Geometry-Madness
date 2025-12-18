extends Control



func _input(_event : InputEvent) -> void:
	if Input.is_action_just_pressed("Escape"):
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused


func resume():
	hide()
	get_tree().paused = false


func exit():
	hide()
	get_tree().paused = false
	get_tree().change_scene_to_file(GlobalReferences.main_menu_scene)


func open_debug():
	pass
