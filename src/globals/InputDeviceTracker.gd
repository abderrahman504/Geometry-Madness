extends Node

# Singleton script
## Tracks which input device is currently in use and provides appropriate icons for inputs.


## Emiited when the current input device is changed.
signal device_changed(device : Device)


const XBOX_CONTROLLER := "XBOX Controller"
const PLAYSTATION_CONTROLLER := "Playstation Controller"
const KEYBOARD_AND_MOUSE := "Keyboard & Mouse"
const GENERIC_CONTROLLER := "Generic Controller"

enum Device{KEYBOARD, XBOX, PLAYSTATION, GENERIC}

## Maps Device enum values to Strings for the device name.
var device_names := {
	Device.KEYBOARD : KEYBOARD_AND_MOUSE,
	Device.XBOX : XBOX_CONTROLLER,
	Device.PLAYSTATION : PLAYSTATION_CONTROLLER,
	Device.GENERIC : GENERIC_CONTROLLER,
}

## Maps Device enum values to Texture2Ds for controller icons
var device_icons := {
	Device.KEYBOARD : preload("res://assets/textures/Input/Keyboard-Mouse/keyboard.svg"),
	Device.XBOX : preload("res://assets/textures/Input/Xbox/controller_xboxone.svg"),
	Device.PLAYSTATION : preload("res://assets/textures/Input/PlayStation/controller_playstation5.svg"),
	Device.GENERIC : preload("res://assets/textures/Input/Generic/controller_wiiu_pro.svg"),
}

var _current_device : Device = Device.KEYBOARD
var current_device : Device:
	get: return _current_device


func _input(event : InputEvent) -> void:
	var input_device : Device
	if (event is InputEventMouse or
	event is InputEventKey):
		input_device = Device.KEYBOARD

	else:
		match Input.get_joy_name(event.device):
			"XInput Gamepad", "Xbox Series Controller", "Xbox 360 Controller", "Xbox One Controller":
				input_device = Device.XBOX

			"Sony DualSense", "PS5 Controller", "PS4 Controller", "Nacon Revolution Unlimited Pro Controller":
				input_device = Device.PLAYSTATION

			_:
				input_device = Device.GENERIC
	
	if input_device != _current_device:
		_current_device = input_device
		device_changed.emit(_current_device)

