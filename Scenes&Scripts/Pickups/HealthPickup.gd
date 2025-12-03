extends "res://Scenes&Scripts/Pickups/BasePickup.gd"


@export var restoredHealth : int = 5;


func run_pickup_effect():
	var player = GlobalReferences.player
	player.recieve_damage(-1 * restoredHealth)
	if player.health > player.maxHealth:
		player.health = player.maxHealth
