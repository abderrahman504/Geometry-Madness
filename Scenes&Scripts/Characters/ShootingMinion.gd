extends BaseEnemy
class_name ShootingPursuer

## Moves towards the player and shoots him.
## The shooting pursuer does not drop a gun on death


var desired_player_range : float = 50



func handle_movement(delta):
	if not GlobalReferences.playerExists:
		return
	
	var dist_to_player := position.distance_to(GlobalReferences.player.position)
	if dist_to_player > desired_player_range:
		velocity = (GlobalReferences.player.position - position).normalized()
		velocity *= max_speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
	


func handle_shooting(delta):
	super.handle_shooting(delta)
	
	




func drop_gun():
	return


