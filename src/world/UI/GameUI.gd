extends Control
class_name GameUI

var ammo_bars : GridContainer:
	get:
		return $AmmoBars

var score_counter : ScoreCounter:
	get:
		return $ScoreCounter

func _init():
	GlobalReferences.game_ui = self
