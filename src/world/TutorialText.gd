extends PanelContainer
class_name TutorialText


var _font_size : int

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

enum {START, SHOOT, KILL_OCTAGON, PICKUP1, KILL_SQUARE, PICKUP2, END}

var _stage : int = START

var _start_text := "{0} to look.
{1} to move."

var _start_inserts := {
	InputDeviceTracker.Device.KEYBOARD : ["[img=30]res://assets/textures/Input/Keyboard-Mouse/mouse_move.svg[/img]", "[img=30]res://assets/textures/Input/Keyboard-Mouse/keyboard_w.svg[/img][img=30]res://assets/textures/Input/Keyboard-Mouse/keyboard_a.svg[/img][img=30]res://assets/textures/Input/Keyboard-Mouse/keyboard_s.svg[/img][img=30]res://assets/textures/Input/Keyboard-Mouse/keyboard_d.svg[/img] or arrow keys"],
	InputDeviceTracker.Device.XBOX : ["[img=30]res://assets/textures/Input/PlayStation/playstation_stick_r.svg[/img]", "[img=30]res://assets/textures/Input/PlayStation/playstation_stick_r.svg[/img]"],
	InputDeviceTracker.Device.PLAYSTATION : ["[img=30]res://assets/textures/Input/PlayStation/playstation_stick_r.svg[/img]", "[img=30]res://assets/textures/Input/PlayStation/playstation_stick_r.svg[/img]"],
	InputDeviceTracker.Device.GENERIC : ["[img=30]res://assets/textures/Input/PlayStation/playstation_stick_r.svg[/img]", "[img=30]res://assets/textures/Input/PlayStation/playstation_stick_r.svg[/img]"],
}

var _shoot_text := "{0} to shoot."
var _shoot_inserts := {
	InputDeviceTracker.Device.KEYBOARD : ["[img=30]res://assets/textures/Input/Keyboard-Mouse/mouse_left.svg[/img]"],
	InputDeviceTracker.Device.XBOX : ["[img=30]res://assets/textures/Input/Xbox/xbox_lt.svg[/img]"],
	InputDeviceTracker.Device.PLAYSTATION : ["[img=30]res://assets/textures/Input/PlayStation/playstation_trigger_l2.svg[/img]"],
	InputDeviceTracker.Device.GENERIC : ["[img=30]res://assets/textures/Input/Xbox/xbox_lt.svg[/img]"],
}

var _kill_oct_text := "Kill the Octagon!"
var _pickup1_text := "Pick up the gun drop before it disappears."
var _kill_square_text := "Kill the Square before it kills you!"
var _pickup2_text := "Pick up the square gun."


@onready var label : RichTextLabel = $RichTextLabel


func _ready() -> void:
	_font_size = SettingsManager.get_attribute("Font Size") + 4
	SettingsManager.attribute_updated.connect(func(attr, val): if attr == "Font Size": _on_font_size_changed(val))
	InputDeviceTracker.device_changed.connect(_on_device_changed)

	_update_stage()


func next_stage() -> void:
	# Determine the next stage
	if _stage != END:
		_stage += 1

	_update_stage()


func _update_stage() -> void:
	# Determine the contents of the tutorial text based on input device and stage
	var text : String = "[font_size=%d]" % _font_size
	if _stage == START:
		text = text + _start_text.format(_start_inserts[InputDeviceTracker.current_device])
		
	elif _stage == SHOOT:
		text = text + _shoot_text.format(_shoot_inserts[InputDeviceTracker.current_device])
	
	elif _stage == KILL_OCTAGON:
		text = text + _kill_oct_text
	elif _stage == PICKUP1:
		text = text + _pickup1_text
		
	elif _stage == KILL_SQUARE:
		text = text + _kill_square_text
	
	elif _stage == PICKUP2:
		text = text + _pickup2_text
		
	elif _stage == END:
		hide()

	label.text = text + "[/font_size]"


func _on_device_changed(_device : InputDeviceTracker.Device) -> void:
	# Update text based on stage and new device
	_update_stage()


func _on_font_size_changed(value : int) -> void:
	_font_size = value + 4
	_update_stage()
