extends Square
class_name Lvl2Square

## Level 2 of the Square dodges player bullets when they get close enough.

@export  var dodgeCooldown : float = 5 ## Cooldown duration after using dodge.
@export var dodgeDistance : float = 35
@export var dodgeAccel : float = 1000
@export var dodge_max_speed : float = 1000
var dodgeCooldownCounter : float = 0
var dodgeStartPoint : Vector2
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
			if velocity.length() <= max_speed:
				dodging = false
		else:
			velocity = velocity.move_toward(dodgeVector*dodge_max_speed, dodgeAccel*delta)
	else:
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


func dodge(bullet : Area2D):
	var forward : Vector2 = Vector2.from_angle(rotation)
	var bulletVector : Vector2 = bullet.position - position
	var bulletMoveVector : Vector2 = bullet.velocity.normalized()
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



