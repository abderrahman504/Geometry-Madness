extends "res://Scenes&Scripts/Characters/BaseEnemy.gd"

var moving : bool = false
var destination : Vector2 = Vector2(-1, -1)
var slowingDown : bool = false


func _ready():
	super._ready()
	gun = $HeavyCanon
	gun.user = self
	gunDropPath = GlobalReferences.GunDropPaths["heavy canon"];
	enemyType = GlobalReferences.COLOURS.Blue;
	
	find_destination()
	moving = true
	attackIntervalCounter = attackInterval


func handle_movement(delta):
	# The pentagon doesn't move normally. When it is too far from the player it dashes to a position that's close to them.
	if not (GlobalReferences.playerExists):
		return
	if not moving:
		look_at(player.position)
		return
	var travelDirection : Vector2 = (destination - position).normalized() * speed
	look_at(position + travelDirection)
	if slowingDown:
		travelDirection = Vector2.ZERO
		if velocity == Vector2.ZERO:
			slowingDown = false
			moving = false
			attackIntervalCounter = attackInterval
	
	velocity = velocity.move_toward(travelDirection, acceleration * delta)
	if (destination - position).length() < speed:
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



func find_destination():
	# Honestly I'm not sure what the hell this is doing. Trying to find a position on a circle with radius r around the player??
	# Whatever it is it's very badly written. Goddamn you younger me.
	var playerPos : Vector2 = GlobalReferences.player.position
	var r = 200
	var x
	var xUpperBound
	var xLowerBound
	var y
	var yUpperBound
	var yLowerBound
	
	xLowerBound = max(playerPos.x - r, GlobalReferences.sceneRoot.TLCorner.x)
	xUpperBound = min(playerPos.x + r, GlobalReferences.sceneRoot.BRCorner.x)
	var randNoGen = RandomNumberGenerator.new()
	x = randNoGen.randi_range(xLowerBound, xUpperBound)
	
	
	var R = sqrt(r*r - (x-playerPos.x)*(x-playerPos.x))
	yLowerBound = max(playerPos.y - R, GlobalReferences.sceneRoot.TLCorner.y)
	yUpperBound = min(playerPos.y + R, GlobalReferences.sceneRoot.BRCorner.y)
	
	y = randNoGen.randi_range(yLowerBound, yUpperBound)
	destination = Vector2(x,y)






