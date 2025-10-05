extends BaseEnemy
class_name Hexagon

## The hexagon will orbit the player, switching between CW and CCW as attack intervals pass.

var clockwiseMove : bool = false
var maxRange : float = 250



func _ready():
	super._ready()
	gun = $SplitRifle
	gun.user = self
	gunDropPath = GlobalReferences.GunDropPaths["split rifle"];
	enemyType = GlobalReferences.COLOURS.Yellow;


func _process(delta):
	handle_shooting(delta)


func _physics_process(delta):
	handle_movement(delta)


func handle_movement(delta):
	if not GlobalReferences.playerExists:
		return
	look_at(player.position)
	# The hexagon orbits the player and slowly gets closer to them
	# It will try to approach faster if the player is far away
	var dir := -1 if clockwiseMove else 1
	# moveVector moves the hexagon in a slightly tightening orbit around the player
	var moveVector := (player.position - position).orthogonal().normalized()*dir + (player.position - position).normalized()*0.5
	var dFromPlayer : float = (position - player.position).length()
	# The orbit tightens faster if the player is too far
	if dFromPlayer >= maxRange:
		moveVector += (player.position - position).normalized()
	
	velocity = velocity.move_toward(moveVector*max_speed, acceleration * delta)
	move_and_slide()



func handle_shooting(delta):
	if not GlobalReferences.playerExists:
		return
	
	if breakTimeCounter <= 0:
		gun.shoot(player.position)
		if attackIntervalCounter <= 0:
			breakTimeCounter = breakTime
			attackIntervalCounter = attackInterval
			clockwiseMove = not clockwiseMove
		
		attackIntervalCounter -= delta
	
	breakTimeCounter -=delta


