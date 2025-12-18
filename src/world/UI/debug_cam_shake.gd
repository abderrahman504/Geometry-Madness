extends VBoxContainer

@export var camera_shaker : Shaker



func _on_button_button_up():
	var duration := float($Duration/LineEdit.placeholder_text 
		if $Duration/LineEdit.text.is_empty() else
			$Duration/LineEdit.text)
	var strength := float($Strength/LineEdit.placeholder_text 
		if $Strength/LineEdit.text.is_empty() else
			$Strength/LineEdit.text)
	var dist := float($Dist/LineEdit.placeholder_text 
		if $Dist/LineEdit.text.is_empty() else
			$Dist/LineEdit.text)
	var dir := Vector2(
		float($Dir/LineEdit.placeholder_text 
			if $Dir/LineEdit.text.is_empty() else
				$Dir/LineEdit.text),
		float($Dir/LineEdit2.placeholder_text 
			if $Dir/LineEdit2.text.is_empty() else
				$Dir/LineEdit2.text),
	)
	
	camera_shaker.duration = duration
	camera_shaker.dist = dist
	camera_shaker.frequency = strength
	camera_shaker.shake(dir)
