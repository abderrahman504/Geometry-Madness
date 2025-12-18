extends BasePickup


@export var gunType: GlobalReferences.GUNTYPES


func run_pickup_effect():
	GlobalReferences.player.get_new_gun(gunType)

