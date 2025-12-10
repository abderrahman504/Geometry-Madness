extends TextureProgressBar



func _on_visible_on_screen_notifier_2d_screen_entered():
	$KeepOnScreen.set_active(true)


func _on_visible_on_screen_notifier_2d_screen_exited():
	$KeepOnScreen.set_active(false)
