extends Control

@onready var resolution : OptionButton = %resolution
@onready var fullscreen : CheckBox = %fullscreen
@onready var vsync : CheckBox = %vsync
@onready var soundeffcts : HSlider = %soundeffects
@onready var music : HSlider = %music
@onready var difficulty : HSlider = %difficulty
@onready var fontsize : HSlider = %fontsize
@onready var camshake : HSlider = %camshake


# Called when the node enters the scene tree for the first time.
func _ready():
	# Set components to settings values
	# Resolution
	resolution.clear()
	var selected_idx : int = 0
	var values : Array = SettingsManager._registered_attrs["Resolution"].values
	for i in range(values.size()):
		resolution.add_item(values[i])
		if values[i] == SettingsManager.get_attribute("Resolution"):
			selected_idx = i
	resolution.select(selected_idx)

	# Fullscreen
	fullscreen.button_pressed = SettingsManager.get_attribute("Fullscreen")
	
	# VSync
	vsync.button_pressed = SettingsManager.get_attribute("VSync")

	# Sound effects
	soundeffcts.value = SettingsManager.get_attribute("Sound Effects")
	$Panel/MarginContainer/VBoxContainer/Audio/SoundEffects/Value.text = str(soundeffcts.value)
	# Music
	music.value = SettingsManager.get_attribute("Music")
	$Panel/MarginContainer/VBoxContainer/Audio/Music/Value.text = str(music.value)

	# Difficulty
	difficulty.value = SettingsManager.get_attribute("Difficulty")
	$Panel/MarginContainer/VBoxContainer/Game/Difficulty/Value.text = str(difficulty.value)

	# Font size
	fontsize.value = SettingsManager.get_attribute("Font Size")
	$Panel/MarginContainer/VBoxContainer/Game/FontSize/Value.text = str(fontsize.value)

	# Camera Shake
	camshake.value = SettingsManager.get_attribute("Camera Shake Intensity")
	$Panel/MarginContainer/VBoxContainer/Game/CamShakeIntensity/Value.text = str(camshake.value)



func _on_resolution_item_selected(index):
	var value = resolution.get_item_text(index)
	var success = SettingsManager.set_attribute("Resolution", value)
	if not success:
		printerr("Failed to set value for settings attribute 'Resolution'")


func _on_fullscreen_toggled(button_pressed):
	var success = SettingsManager.set_attribute("Fullscreen", button_pressed)
	if not success:
		printerr("Failed to set value for settings attribute 'Fullscreen'")


func _on_vsync_toggled(button_pressed):
	var success = SettingsManager.set_attribute("VSync", button_pressed)
	if not success:
		printerr("Failed to set value for settings attribute 'VSync'")


func _on_soundeffects_value_changed(value):
	$Panel/MarginContainer/VBoxContainer/Audio/SoundEffects/Value.text = str(value)


func _on_soundeffects_drag_ended(value_changed):
	if not value_changed:
		return
	var success = SettingsManager.set_attribute("Sound Effects", soundeffcts.value)
	if not success:
		printerr("Failed to set value for settings attribute 'Sound Effects'")


func _on_music_value_changed(value):
	$Panel/MarginContainer/VBoxContainer/Audio/Music/Value.text = str(value)


func _on_music_drag_ended(value_changed):
	if not value_changed:
		return
	var success = SettingsManager.set_attribute("Music", music.value)
	if not success:
		printerr("Failed to set value for settings attribute 'Music'")


func _on_difficulty_value_changed(value):
	$Panel/MarginContainer/VBoxContainer/Game/Difficulty/Value.text = str(value)


func _on_difficulty_drag_ended(value_changed):
	if not value_changed:
		return
	var success = SettingsManager.set_attribute("Difficulty", int(difficulty.value))
	if not success:
		printerr("Failed to set value for settings attribute 'Difficulty'")


func _on_fontsize_value_changed(value):
	$Panel/MarginContainer/VBoxContainer/Game/FontSize/Value.text = str(value)


func _on_fontsize_drag_ended(value_changed):
	if not value_changed:
		return
	var success = SettingsManager.set_attribute("Font Size", int(fontsize.value))
	if not success:
		printerr("Failed to set value for settings attribute 'Font Size'")


func _on_camshake_value_changed(value):
	$Panel/MarginContainer/VBoxContainer/Game/CamShakeIntensity/Value.text = "%1.1f" % value


func _on_camshake_drag_ended(value_changed):
	if not value_changed:
		return
	var success = SettingsManager.set_attribute("Camera Shake Intensity", camshake.value)
	if not success:
		printerr("Failed to set value for settings attribute 'Camera Shake Intensity'")


func _on_close_toggled(_button_pressed):
	SettingsManager.save_settings()
	get_tree().change_scene_to_file(GlobalReferences.main_menu_scene)
