extends Node2D


var myOwner : CharacterBody2D




func _process(_delta):
	global_position = myOwner.position
	global_rotation = 0
