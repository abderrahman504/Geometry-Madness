extends Node2D

func _process(delta):
	
	$AnimationPlayer.play("ScaleUp")
	
	await $AnimationPlayer.animation_finished
	
	queue_free()
	
	pass
