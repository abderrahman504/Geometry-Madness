extends CharacterBody2D

var enemyType : int = -1
var orbitMinRange : float = 50
var orbitMaxRange : float = 55
var dFromParent : float
var speed : float = 100
var acceletation : float = 250
var velocity : Vector2
var touchDamage : int = 2
var aggroTriggerRange : float = 220
var aggroed : bool = false
var aggroBreakerRange : float = 300
var dFromPlayer : float 
var player : CharacterBody2D
var parent : CharacterBody2D
var rotationalSpeed : float = 2


func _ready():
	player = GlobalReferences.player



func _physics_process(delta):
	handle_movement(delta)
	if get_slide_collision_count() > 0:
		for i in range(get_slide_collision_count()-1):
			var collision : KinematicCollision2D = get_slide_collision(i)
			if collision.collider == player:
				player.recieve_damage(touchDamage)
				recieve_damage(1)
				break
				



func handle_movement(delta):
	if not GlobalReferences.playerExists:
		return
	
	rotation += rotationalSpeed * delta
	
	dFromPlayer = (player.position - position).length()
	dFromParent = (parent.position - position).length()
	
	if aggroed and dFromPlayer <= aggroBreakerRange:
		velocity = velocity.move_toward(chase_player(), acceletation * delta)
	elif dFromPlayer <= aggroTriggerRange:
		aggroed = true
	else:
		aggroed = false
		velocity = velocity.move_toward(follow_parent(), acceletation * delta)
	
	set_velocity(velocity)
	move_and_slide()
	velocity = velocity


func follow_parent():
	var vectorToParent : Vector2 = (parent.position - position).normalized()
	var moveVector : Vector2 = vectorToParent.orthogonal()
	if dFromParent > orbitMaxRange or dFromParent < orbitMinRange:
		
		var s = pow(-1 ,int(dFromParent < orbitMinRange))
		moveVector = moveVector + vectorToParent * s
	return (moveVector*speed)


func chase_player():
	return ((player.position - position).normalized() * speed)


func recieve_damage(damage):
	queue_free()
	parent.minions.erase(self)










