extends GridContainer
class_name AmmoBars

var bar1 : TextureProgressBar
var bar2 : TextureProgressBar
var gun1 : Node = null
var gun2 : Node = null
var tween : Tween

var baseTints : PackedColorArray = [Color("00258b"), Color("c00000"), Color("ffef00")]
enum BASETINTS {Blue, Red, Yellow}



func _ready():
	bar1 = $Bar1
	bar2 = $Bar2
	bar1.value = 0
	bar2.value = 0


func update_ammo_bar():
	bar1.tint_progress = GlobalReferences.colours[gun1.gunType]
	if tween != null:
		tween.kill()
	tween = create_tween()
	tween.tween_property(bar1, "value", gun1.ammoCount, 0.2)
	tween.tween_property(bar2, "value", 0, 0.2)


func update_mixed_ammo_bar():
	bar1.tint_progress = GlobalReferences.colours[gun1.gunType]
	bar2.tint_progress = GlobalReferences.colours[gun2.gunType]
	if tween != null:
		tween.kill()
	tween = create_tween()	
	tween.tween_property(bar1, "value", gun1.ammoCount, 0.2)
	tween.tween_property(bar2, "value", gun2.ammoCount, 0.2)

