extends Control



func on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes&Scripts/World/MainWorld.tscn")


func on_tutorial_pressed():
	get_tree().change_scene_to_file("res://Scenes&Scripts/Other/Tutorial.tscn")


func on_credits_pressed():
	get_tree().change_scene_to_file("res://Scenes&Scripts/Other/Credits.tscn")


func on_exit_pressed():
	get_tree().quit()
