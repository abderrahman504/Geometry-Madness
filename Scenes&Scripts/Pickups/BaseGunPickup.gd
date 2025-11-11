extends "res://Scenes&Scripts/Pickups/BasePickup.gd"


@export var gunType: GlobalReferences.GUNTYPES


func run_pickup_effect():
	player.get_new_gun(gunType)

