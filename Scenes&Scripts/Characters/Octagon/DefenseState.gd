extends State
class_name DefenseState

signal teleported

var character : BaseEnemy

@export var charge_bar : TextureProgressBar

var charge_timer : float

## The time it takes to fully charge the teleport
@export var teleport_charge_time : float



func enter() -> void:
	print("Defense entered")
	charge_timer = 0
	charge_bar.show()
	charge_bar.max_value = 100
	charge_bar.value = 0


func exit() -> void:
	charge_bar.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta : float) -> void:
	print("Defense update")
	if charge_timer >= teleport_charge_time:
		teleport()
	charge_timer += delta
	charge_bar.value = 100 * (teleport_charge_time - charge_timer) / teleport_charge_time


func teleport() -> void:
	teleported.emit()
