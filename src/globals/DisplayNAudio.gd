extends Node

## Singleton script

var bus_max_vol := 0.0
var bus_min_vol := -80.0

var ui_themes : Array[Theme] = [
	preload("res://assets/ui theme/kenneyUI.tres"),
	preload("res://assets/ui theme/kenneyUI-green.tres"),
	
]

func _ready() -> void:
	# Connect Attribute change signals
	SettingsManager.attribute_updated.connect(_on_attribute_updated)


	# Read initial values for attributes
	var res = SettingsManager.get_attribute("Resolution")
	# If attributes haven't been set yet then stop
	if res == null:
		return
	_on_attribute_updated("Resolution", res)
	
	res = SettingsManager.get_attribute("Fullscreen")
	_on_attribute_updated("Fullscreen", res)

	res = SettingsManager.get_attribute("VSync")
	_on_attribute_updated("VSync", res)
	
	res = SettingsManager.get_attribute("Sound Effects")
	_on_attribute_updated("Sound Effects", res)
	
	res = SettingsManager.get_attribute("Music")
	_on_attribute_updated("Music", res)
	
	res = SettingsManager.get_attribute("Font Size")
	_on_attribute_updated("Font Size", res)


func _on_attribute_updated(attr : String, value) -> void:
	match attr:
		#"Resolution":

		
		"Fullscreen":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if value else DisplayServer.WINDOW_MODE_WINDOWED)
		
		"VSync":
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if value else DisplayServer.VSYNC_DISABLED)
		
		"Sound Effects":
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound Effects"), percent_to_db(value * 0.01))
		
		"Music":
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), percent_to_db(value * 0.01))
		
		"Font Size":
			for ui_theme in ui_themes:
				var base_size = ui_theme.get_theme_item(Theme.DATA_TYPE_FONT_SIZE, "font_size", "S5Label")
				ui_theme.set_theme_item(Theme.DATA_TYPE_FONT_SIZE, "font_size", "S5Label", value)
				var diff = base_size - ui_theme.get_theme_item(Theme.DATA_TYPE_FONT_SIZE, "font_size", "S4Label")
				ui_theme.set_theme_item(Theme.DATA_TYPE_FONT_SIZE, "font_size", "S4Label", value - diff)
				diff = base_size - ui_theme.get_theme_item(Theme.DATA_TYPE_FONT_SIZE, "font_size", "S3Label")
				ui_theme.set_theme_item(Theme.DATA_TYPE_FONT_SIZE, "font_size", "S3Label", value - diff)
				diff = base_size - ui_theme.get_theme_item(Theme.DATA_TYPE_FONT_SIZE, "font_size", "S2Label")
				ui_theme.set_theme_item(Theme.DATA_TYPE_FONT_SIZE, "font_size", "S2Label", value - diff)
				diff = base_size - ui_theme.get_theme_item(Theme.DATA_TYPE_FONT_SIZE, "font_size", "S1Label")
				ui_theme.set_theme_item(Theme.DATA_TYPE_FONT_SIZE, "font_size", "S1Label", value - diff)
				diff = base_size - ui_theme.get_theme_item(Theme.DATA_TYPE_FONT_SIZE, "font_size", "H1Label")
				ui_theme.set_theme_item(Theme.DATA_TYPE_FONT_SIZE, "font_size", "H1Label", value - diff)
				diff = base_size - ui_theme.get_theme_item(Theme.DATA_TYPE_FONT_SIZE, "font_size", "H2Label")
				ui_theme.set_theme_item(Theme.DATA_TYPE_FONT_SIZE, "font_size", "H2Label", value - diff)
				diff = base_size - ui_theme.get_theme_item(Theme.DATA_TYPE_FONT_SIZE, "font_size", "H3Label")
				ui_theme.set_theme_item(Theme.DATA_TYPE_FONT_SIZE, "font_size", "H3Label", value - diff)



func percent_to_db(percent : float) -> float:
	return (bus_max_vol - bus_min_vol) * percent + bus_min_vol
