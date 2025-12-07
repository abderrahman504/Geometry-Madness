extends State
class_name ActiveState


var character : BaseEnemy



func _update(delta : float) -> void:
	super._update(delta)
	character.handle_shooting(delta)
	
