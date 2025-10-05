extends Node2D

signal animation_finished

func _ready():
	$AnimationPlayer.play("Nuova Animazione")


func _on_AnimationPlayer_animation_finished(anim_name):
	animation_finished.emit()
