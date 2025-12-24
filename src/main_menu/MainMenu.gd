extends Control


@export var tutorial_scene : PackedScene


func on_play_pressed():
	get_tree().change_scene_to_file(GlobalReferences.main_level_scene)


func on_tutorial_pressed():
	get_tree().change_scene_to_packed(tutorial_scene)


func on_credits_pressed():
	get_tree().change_scene_to_file("res://src/main_menu/Credits.tscn")


func on_exit_pressed():
	get_tree().quit()


func _on_settings_pressed():
	get_tree().change_scene_to_file("res://src/main_menu/settings_menu.tscn")
