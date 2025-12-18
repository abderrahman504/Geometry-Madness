extends Button

@export var start_focused: bool = false

func _ready():
	if(start_focused):
		grab_focus()
	
	connect("mouse_entered", Callable(self, "_on_Button_mouse_entered"))

func _on_Button_mouse_entered():
	$Switch.play()
	grab_focus()

