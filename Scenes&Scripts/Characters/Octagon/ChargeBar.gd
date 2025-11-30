extends TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_visible_on_screen_notifier_2d_screen_entered():
	$KeepOnScreen.set_active(true)


func _on_visible_on_screen_notifier_2d_screen_exited():
	$KeepOnScreen.set_active(false)
