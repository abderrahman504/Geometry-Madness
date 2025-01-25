extends "res://Scenes&Scripts/Characters/Square.gd"

@export  var dodgeCooldown : float = 5
var dodgeCooldownCounter : float = 0
@export var dodgeDistance : float = 35
var dodgeStartPoint : Vector2
var dodgeAccel : float = 1000
var dodgeSpeed : float = 1000
var dodging : bool = false
var dodgeVector : Vector2


func _process(delta):
	super._process(delta)
	dodgeCooldownCounter -= delta




func handle_movement(delta):
	if not GlobalReferences.playerExists:
		return
	
	look_at(player.position)
	if dodging:
		if (position - dodgeStartPoint).length() >= dodgeDistance:
			velocity = velocity.move_toward(Vector2.ZERO, dodgeAccel*delta)
			if velocity.length() <= speed:
				dodging = false
		else:
			velocity = velocity.move_toward(dodgeVector*dodgeSpeed, dodgeAccel*delta)
	else:
		var dFromPlayer = (player.position - position).length()
		if dFromPlayer > maxRange:
			velocity = (player.position - position).normalized() * speed
		elif dFromPlayer < minRange:
			velocity = (position - player.position).normalized() * speed
		else:
			velocity = (player.position - position).normalized() * ((dFromPlayer - rangeMidPoint) / (0.5*(maxRange-minRange))) * speed
			if abs(dFromPlayer - rangeMidPoint) <= (maxRange-minRange)*0.1:
				velocity = Vector2.ZERO
	
	move_and_slide()


func dodge(Bullet : Area2D):
	var forward : Vector2 = Vector2(cos(rotation), sin(rotation))
	var bulletVector : Vector2 = Bullet.position - position
	var bulletMoveVector : Vector2 = Bullet.velocity.normalized()
	var bulletApproachAngle : float = asin(forward.cross(bulletVector) / bulletVector.length())
	if bulletApproachAngle == 0:
		bulletApproachAngle = 1
	
	dodgeVector = Vector2(-bulletMoveVector.y, bulletMoveVector.x).normalized() * sign(bulletApproachAngle)
	dodgeStartPoint = position


func on_bullet_detected(area):
	if dodgeCooldownCounter > 0:
		return
	
	dodge(area)
	dodging = true
	dodgeCooldownCounter = dodgeCooldown



