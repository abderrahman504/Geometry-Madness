extends State

## In this state, the short teleport is being charged and cannot be used.

signal short_teleport_charged

@export var short_teleport_bar : TextureProgressBar
@export var charge_time : float = 3
var charge_timer : float = 0


func _enter() -> void:
	super._enter()
	charge_timer = 0
	short_teleport_bar.show()
	short_teleport_bar.max_value = 100
	short_teleport_bar.value = 0


func _exit() -> void:
	super._exit()
	short_teleport_bar.hide()


func _update(delta : float) -> void:
	super._update(delta)
	if charge_timer >= charge_time:
		short_teleport_charged.emit()
	charge_timer += delta
	short_teleport_bar.value = (charge_timer / charge_time) * 100

