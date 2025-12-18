extends Node2D


var myOwner : CharacterBody2D




func _process(_delta):
	if not is_instance_valid(myOwner):
		queue_free()
		return
	global_position = myOwner.global_position + myOwner.get_node("HealthbarPos").position
