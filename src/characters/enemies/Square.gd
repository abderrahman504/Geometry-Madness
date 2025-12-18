extends BaseEnemy
class_name Square

## A square enemy tries to position itself somewhere between the minimum and maximum ranges from the player.


@export var minRange : float = 400
@export var maxRange : float = 700
## This is the sweetspot. A distance to the player the square would like to stay at.
var rangeMidPoint : float:
	get: return (maxRange + minRange)/2 



func _process(delta):
	handle_shooting(delta)


func _physics_process(delta):
	handle_movement(delta)


func handle_movement(_delta):
	if not GlobalReferences.playerExists:
		return
	
	look_at(player.position)
	
	var d_to_player = (player.position - position).length()
	if d_to_player > maxRange or d_to_player < minRange:
		velocity = (player.position - position).normalized() * max_speed * (1 if d_to_player > maxRange else -1)
	else:
		# The further the square is from the sweetspot, the faster it will move to reach it.
		var speed : float = clampf(((d_to_player - rangeMidPoint) / (0.5*(maxRange - minRange))), 0, 1) * max_speed
		velocity = (player.position - position).normalized() * speed
		if abs(d_to_player - rangeMidPoint) <= speed:
			velocity = Vector2.ZERO
	
	move_and_slide()


func handle_shooting(delta):
	if not GlobalReferences.playerExists:
		return
	
	if (player.position - position).length() > maxRange:
		return
	super.handle_shooting(delta)







