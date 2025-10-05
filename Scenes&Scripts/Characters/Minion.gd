extends CharacterBody2D

var enemyType : int = -1
var orbitMinRange : float = 90
var orbitMaxRange : float = 100
var dFromParent : float
var speed : float = 100
var acceleration : float = 250
var touchDamage : int = 2
var aggroTriggerRange : float = 220
var aggroed : bool = false
var aggroBreakerRange : float = 300
var dFromPlayer : float 
var player : CharacterBody2D
var parent : CharacterBody2D
var rotationalSpeed : float = 2


func _ready():
	print("I'm a minion")
	player = GlobalReferences.player



func _physics_process(delta):
	handle_movement(delta)
	if get_slide_collision_count() > 0:
		for i in range(get_slide_collision_count()-1):
			var collision : KinematicCollision2D = get_slide_collision(i)
			if collision.get_collider() == player:
				player.recieve_damage(touchDamage)
				recieve_damage(1)
				break
				



func handle_movement(delta):
	if not GlobalReferences.playerExists:
		return
	
	rotation += rotationalSpeed * delta
	
	dFromPlayer = (player.position - position).length()

	if parent == null or (aggroed and dFromPlayer <= aggroBreakerRange):
		print("chasing player")
		velocity = velocity.move_toward(chase_player(), acceleration * delta)
	elif not aggroed and dFromPlayer <= aggroTriggerRange:
		aggroed = true
	else:
		print("following parent")
		aggroed = false
		velocity = velocity.move_toward(follow_parent(), acceleration * delta)
	
	move_and_slide()


func follow_parent():
	var vectorToParent : Vector2 = (parent.position - position).normalized()
	var moveVector : Vector2 = vectorToParent.orthogonal()
	if dFromParent > orbitMaxRange or dFromParent < orbitMinRange:
		var s = 1 if dFromParent < orbitMinRange else -1
		moveVector = moveVector + vectorToParent * s
		
	return (moveVector*speed)


func chase_player():
	return ((player.position - position).normalized() * speed)


func recieve_damage(_damage):
	print("minion destroyed")
	queue_free()
	if parent != null:
		parent.minions.erase(self)










