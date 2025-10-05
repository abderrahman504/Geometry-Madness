extends Pentagon
class_name Lvl2Pentagon

## Instead of moving at normal speed, level 2 pentagon dashes to the point.


var dashing : bool = false
var dashingTime : float
var dashingTimeCounter : float = 0
var beforeDashTime : float = 2
var beforeDashTimeCounter : float = 0


func handle_movement(delta):
	# Level 2 pentagon dashes to a point near the player, then starts shooting.
	if not GlobalReferences.playerExists:
		return
	if not moving:
		look_at(player.position)
		return
	if beforeDashTimeCounter <= beforeDashTime:
		beforeDashTimeCounter += delta
		return
	
	if dashing == false:
		dash()
	
	if dashingTimeCounter >= dashingTime:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	dashingTimeCounter += delta
	
	if velocity == Vector2.ZERO:
		moving = false
		dashing = false
		beforeDashTimeCounter = 0
		dashingTimeCounter = 0
		return
	
	var tempVelocity : Vector2 = velocity
	move_and_slide()
	
	if get_slide_collision_count() > 0:
		for i in range(get_slide_collision_count()):
			tempVelocity = handle_collision(get_slide_collision(i), tempVelocity)


func handle_collision(Collision : KinematicCollision2D, oldVelocity : Vector2):
	var momentumLossFactor : float = 0.25
	if Collision.collider is CharacterBody2D:
		var body : CharacterBody2D = Collision.collider
		body.velocity += -Collision.normal * momentumLossFactor * oldVelocity.length()
	
	
	var bounceVector : Vector2 = oldVelocity.bounce(Collision.normal).normalized()
	velocity = bounceVector * oldVelocity.length() * (1-momentumLossFactor)
	dashingTimeCounter = dashingTime
	return velocity


func dash():
	dashing = true
	dashingTime = (destination - position).length() / max_speed
	velocity = (destination - position).normalized() * max_speed

