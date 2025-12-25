extends Control



func _input(_event : InputEvent) -> void:
	if Input.is_action_just_pressed("Escape"):
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused
		$SettingsMenu.visible = !visible


func resume():
	hide()
	get_tree().paused = false


func exit():
	hide()
	get_tree().paused = false
	get_tree().change_scene_to_file(GlobalReferences.main_menu_scene)


func open_debug():
	pass


func _on_settings_pressed():
	$SettingsMenu.show()


func _on_settings_close_pressed():
	$SettingsMenu.hide()
	SettingsManager.save_settings()
