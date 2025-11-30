extends DefenseState
class_name Lvl2Defense

## This defense refinement contains two states.
## The first is one in which a short teleport is charged and ready to be used.
## The second is one in which the short teleport is charging.


func _enter() -> void:
	super._enter()
	$ShortTeleportReady.character = character



func _on_short_teleport_used() -> void:
	current = $ShortTeleportCharging


func _on_short_teleport_charged() -> void:
	current = $ShortTeleportReady