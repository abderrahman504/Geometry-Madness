extends Panel

var shoot_button := {
	InputDeviceTracker.Device.KEYBOARD : "res://assets/textures/Input/Keyboard-Mouse/mouse_left.svg",
	InputDeviceTracker.Device.XBOX : "res://assets/textures/Input/Xbox/xbox_lt.svg",
	InputDeviceTracker.Device.PLAYSTATION : "res://assets/textures/Input/PlayStation/playstation_trigger_l2.svg",
	InputDeviceTracker.Device.GENERIC : "res://assets/textures/Input/Xbox/xbox_lt.svg",
}

var look_button := {
	InputDeviceTracker.Device.KEYBOARD : "res://assets/textures/Input/Keyboard-Mouse/mouse_move.svg",
	InputDeviceTracker.Device.XBOX : "res://assets/textures/Input/PlayStation/playstation_stick_r.svg",
	InputDeviceTracker.Device.PLAYSTATION : "res://assets/textures/Input/PlayStation/playstation_stick_r.svg",
	InputDeviceTracker.Device.GENERIC : "res://assets/textures/Input/PlayStation/playstation_stick_r.svg",
}

var move_button := {
	InputDeviceTracker.Device.XBOX : "res://assets/textures/Input/PlayStation/playstation_stick_l.svg",
	InputDeviceTracker.Device.PLAYSTATION : "res://assets/textures/Input/PlayStation/playstation_stick_l.svg",
	InputDeviceTracker.Device.GENERIC : "res://assets/textures/Input/PlayStation/playstation_stick_l.svg",
}

var wasd := [
	"res://assets/textures/Input/Keyboard-Mouse/keyboard_w.svg",
	"res://assets/textures/Input/Keyboard-Mouse/keyboard_a.svg",
	"res://assets/textures/Input/Keyboard-Mouse/keyboard_s.svg",
	"res://assets/textures/Input/Keyboard-Mouse/keyboard_d.svg",
]

enum {START, KILL_SQUARE, PICKUP1, KILL_OCTAGON, PICKUP2, END}

var _stage : int = START


func _ready() -> void:
	_update_stage()


func _next_stage() -> void:
	# Determine the next stage
	# _stage = ...

	_update_stage()


func _update_stage() -> void:
	# Determine the contents of the tutorial text based on input device and stage
	pass


func _on_device_changed(_device : InputDeviceTracker.Device) -> void:
	# Update text based on stage and new device
	_update_stage()


func _on_square_killed() -> void:
	pass


func _on_gun_picked_up() -> void:
	pass


func _on_octagon_killed() -> void:
	pass

