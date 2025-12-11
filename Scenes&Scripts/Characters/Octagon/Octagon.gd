class_name Octagon
extends BaseEnemy

## The Octagon has two states:
	## - Default : In this state the octagon spawns minions periodically which pursue the player and use a pistol.
	## - Defense : In this state the octagon shoots at the player periodically and charges a long range teleporter to teleport to a safe spot away from the player.

## The octagon starts in the default state and stays in it until the player gets close enough, at which point it enters the defense state.
## Once it teleports at the end of the defense state it switches back to default.



func _process(_delta):
	pass


func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
	#move_and_slide()


