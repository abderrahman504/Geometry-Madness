extends Node

# Singleton script

var settings : Dictionary = {
	"Resolution" : {
		"type" : SettingsManager.AttributeType.ENUMERATION,
		"default" : "1280 x 720",
		"values" : [
			"1920 x 1080",
			"1760 x 990",
			"1680 x 1050",
			"1600 x 900",
			"1366 x 768",
			"1280 x 1024",
			"1280 x 720",
			"1128 x 634",
			"1024 x 768",
			"800 x 600",
			],
	},
	"VSync" : {
		"type" : SettingsManager.AttributeType.BOOL,
		"default" : false,
	},
	"Fullscreen" : {
		"type" : SettingsManager.AttributeType.BOOL,
		"default" : false,
	},
	"Sound Effects" : {
		"type" : SettingsManager.AttributeType.FLOAT,
		"default" : 50,
		"min" : 0,
		"max" : 100,
	},
	"Music" : {
		"type" : SettingsManager.AttributeType.FLOAT,
		"default" : 50,
		"min" : 0,
		"max" : 100,
	},
	"Difficulty" : {
		"type" : SettingsManager.AttributeType.INT,
		"default" : 1,
		"min" : 1,
		"max" : 5,
	},
	"Font Size" : {
		"type" : SettingsManager.AttributeType.INT,
		"default" : 10,
		"min" : 5,
		"max" : 30,
	},
	"Camera Shake Intensity" : {
		"type" : SettingsManager.AttributeType.FLOAT,
		"default" : 0.5,
		"min" : 0.,
		"max" : 1.,
	},
}

func _ready() -> void:
	for attr in settings:
		match (settings[attr].type):
			SettingsManager.AttributeType.INT:
				SettingsManager.register_int_attribute(attr, settings[attr].default, settings[attr].min, settings[attr].max)
			SettingsManager.AttributeType.FLOAT:
				SettingsManager.register_float_attribute(attr, settings[attr].default, settings[attr].min, settings[attr].max)
			SettingsManager.AttributeType.BOOL:
				SettingsManager.register_bool_attribute(attr, settings[attr].default)
			SettingsManager.AttributeType.ENUMERATION:
				SettingsManager.register_enum_attribute(attr, settings[attr].default, settings[attr].values)
