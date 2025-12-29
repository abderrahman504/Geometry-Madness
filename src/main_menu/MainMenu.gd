extends Control

## Maps Device enum values to Texture2Ds for controller icons
var device_icons := {
	InputDeviceTracker.Device.KEYBOARD : preload("res://assets/textures/Input/Keyboard-Mouse/keyboard.svg"),
	InputDeviceTracker.Device.XBOX : preload("res://assets/textures/Input/Xbox/controller_xboxone.svg"),
	InputDeviceTracker.Device.PLAYSTATION : preload("res://assets/textures/Input/PlayStation/controller_playstation5.svg"),
	InputDeviceTracker.Device.GENERIC : preload("res://assets/textures/Input/Generic/controller_wiiu_pro.svg"),
}


func _ready() -> void:
	InputDeviceTracker.device_changed.connect(_on_input_device_changed)

func on_play_pressed():
	get_tree().change_scene_to_file(GlobalReferences.main_level_scene)


func on_tutorial_pressed():
	get_tree().change_scene_to_file("res://src/world/tutorial.tscn")


func on_credits_pressed():
	get_tree().change_scene_to_file("res://src/main_menu/Credits.tscn")


func on_exit_pressed():
	get_tree().quit()


func _on_settings_pressed():
	get_tree().change_scene_to_file("res://src/main_menu/settings_menu.tscn")


func _on_input_device_changed(device : int) -> void:
	$TextureRect.texture = device_icons[device]
	$TextureRect/AnimationPlayer.stop()
	$TextureRect/AnimationPlayer.play("reveal_icon")
