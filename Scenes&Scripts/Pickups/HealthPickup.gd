extends "res://Scenes&Scripts/Pickups/BasePickup.gd"


@export var restoredHealth : int = 5;


func run_pickup_effect():
	var player = GlobalReferences.player
	player.heal(restoredHealth)
