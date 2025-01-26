extends "res://Scenes&Scripts/Pickups/BaseGunPickup.gd"


func _ready():
	super._ready()
	gunType = GlobalReferences.GUNTYPES.HeavyCanon;
