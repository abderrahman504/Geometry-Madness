extends BaseEnemy
class_name Pentagon

## The pentagon moves to a random point around the player, then once it arrives it starts shooting.
## Once the shooting interval ends it moves again.


@export var acceleration: int = 50
@export var deceleration: int = 80
@export var min_range_to_player : float = 150 ## The minimum distance between the player and a point the pentagon chooses to travel to.
@export var max_range_to_player : float = 300 ## The maximum distance between the player and a point the pentagon chooses to travel to.

var moving : bool = false
var destination : Vector2 = Vector2(-1, -1)
var slowingDown : bool = false



func handle_movement(delta):
	# The pentagon picks a random point near the player, moves to it, then starts shooting. This cycle repeats.
	if not (GlobalReferences.playerExists):
		return
	if not moving:
		look_at(player.position)
		return
	var travelDirection : Vector2 = (destination - position).normalized() * max_speed
	look_at(position + travelDirection)
	if slowingDown:
		travelDirection = Vector2.ZERO
		if velocity == Vector2.ZERO:
			slowingDown = false
			moving = false
			attackIntervalCounter = attackInterval
	
	velocity = velocity.move_toward(travelDirection, acceleration * delta)
	if (destination - position).length() < max_speed:
		slowingDown = true
	
	move_and_slide()
	


func handle_shooting(delta):
	if not GlobalReferences.playerExists:
		return
	
	if moving:
		return
	gun.shoot(player.position)
	attackIntervalCounter -= delta
	if attackIntervalCounter <= 0:
		attackIntervalCounter = attackInterval
		find_destination()
		moving = true
		



func _process(delta):
	handle_shooting(delta)


func _physics_process(delta):
	handle_movement(delta)


## Picks a random point around the player to travel to.
func find_destination():
	var playerPos : Vector2 = GlobalReferences.player.position
	
	## Pick a random angle and distance
	var angle := randf_range(0, 2*PI)
	var dist := randf_range(min_range_to_player, max_range_to_player)
	var point : Vector2 = Vector2.from_angle(angle) * dist

	destination = point + playerPos
	# If the destination is outside the walls then mirror the point components it.
	if destination.x < GlobalReferences.sceneRoot.TLCorner.x or destination.x > GlobalReferences.sceneRoot.BRCorner.x:
		point.x = -1* point.x
	if destination.y < GlobalReferences.sceneRoot.TLCorner.y or destination.y > GlobalReferences.sceneRoot.BRCorner.y:
		point.y = -1* point.y

	destination = point + playerPos
