extends VBoxContainer




func _on_damage_text_changed(new_text):
	if new_text == "":
		new_text = $Damage/LineEdit.placeholder_text
	var val := float(new_text)
	GlobalReferences.player.base_gun.bulletDamage = val


func _on_pellets_text_changed(new_text):
	if new_text == "":
		new_text = $Damage/LineEdit.placeholder_text
	var val : int = int(new_text)
	GlobalReferences.player.base_gun.pellet_count = val
