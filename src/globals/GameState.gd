extends Node

# Singleton script


var tutorial_played := false

# Called when the node enters the scene tree for the first time.
func _ready():
	var file := FileAccess.open("user://tutorial_played", FileAccess.READ)
	tutorial_played = file != null


func on_tutorial_played() -> void:
	var file := FileAccess.open("user://tutorial_played", FileAccess.WRITE)
	tutorial_played = true
	file.close()
