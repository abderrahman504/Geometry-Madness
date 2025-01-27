extends "res://Scenes&Scripts/Guns/BaseGun.gd"

var counting : float = 0

func _init():
	gunType = GlobalReferences.GUNTYPES.Machinegun


func _ready():
	shootingAngles = [0]

