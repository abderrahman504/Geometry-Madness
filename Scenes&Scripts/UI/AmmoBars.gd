extends GridContainer
class_name AmmoBars

@onready var _bar1 : TextureProgressBar = $Bar1
@onready var _bar2 : TextureProgressBar = $Bar2


func _ready():
	_bar1.max_value = 100
	_bar2.max_value = 100
	_bar1.value = 0
	_bar2.value = 0


func _process(_delta):
	if not GlobalReferences.playerExists:
		return
	
	var player : Player = GlobalReferences.player
	
	var ammo1 : float = 0
	var ammo2 : float = 0
	var color1 : Color = _bar1.tint_progress
	var color2 : Color = _bar2.tint_progress
	# If a normal gun is used then only one ammo bar is updated while the other is empty
	if player.gun.gunType != GlobalReferences.GUNTYPES.Mixed:
		# If the gun is the pistol then the main bar is also empty
		if player.gun.gunType != GlobalReferences.GUNTYPES.Pistol:
			ammo1 = 100 * player.gun.ammoCount / player.gun.maxAmmo
			color1 = GlobalReferences.colours[player.gun.gunType]
	# Otherwise both ammo bars are updated
	else:
		ammo1 = 100 * player.gun1.ammoCount / player.gun1.maxAmmo
		ammo2 = 100 * player.gun2.ammoCount / player.gun2.maxAmmo
		color1 = GlobalReferences.colours[player.gun1.gunType]
		color2 = GlobalReferences.colours[player.gun2.gunType]
	
	_bar1.tint_progress = color1
	_bar2.tint_progress = color2
	_animate_ammo_bars(ammo1, ammo2)


# Bar animation targets
var _bar1_target : float = 0
var _bar2_target : float = 0
var _tween1 : Tween
var _tween2 : Tween

func _animate_ammo_bars(bar1_tgt : float, bar2_tgt : float) -> void:
	if _bar1_target != bar1_tgt:
		# Animate bar 1
		if _tween1 != null:
			_tween1.kill()
		_tween1 = create_tween()
		_tween1.tween_property(_bar1, "value", bar1_tgt, 0.2)
		_bar1_target = bar1_tgt

	if _bar2_target != bar2_tgt:
		# Animate bar 2
		if _tween2 != null:
			_tween2.kill()
		_tween2 = create_tween()
		_tween2.tween_property(_bar2, "value", bar2_tgt, 0.2)
		_bar2_target = bar2_tgt

