extends CharacterBody2D

var enemyType : int = -1

@export var orbitMinRange : float = 150
@export var orbitMaxRange : float = 160
@export var speed : float = 100
@export var acceleration : float = 250
@export var touchDamage : int = 2
@export var aggroTriggerRange : float = 220
@export var aggroBreakerRange : float = 300
var aggroed : bool = false
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
			if collision.get_collider() == player:
				player.recieve_damage(touchDamage)
				recieve_damage(1)
				break
				



func handle_movement(delta):
	if not GlobalReferences.playerExists:
		return
	
	
	var dFromPlayer = (player.position - position).length()

	if parent == null or (aggroed and dFromPlayer <= aggroBreakerRange):
		arrow_mode = "chase"
		velocity = velocity.move_toward(chase_player(), acceleration * delta)
	elif not aggroed and dFromPlayer <= aggroTriggerRange:
		aggroed = true
		arrow_mode = "none"
	else:
		arrow_mode = "follow"
		aggroed = false
		velocity = velocity.move_toward(follow_parent(), acceleration * delta)
	
	move_and_slide()
	queue_redraw()

func _draw():
	_draw_vector(velocity, Vector2.ZERO)


func follow_parent():
	var vectorToParent : Vector2 = (parent.position - position).normalized()
	var d_to_parent = (parent.position - position).length()
	var moveVector : Vector2 = vectorToParent.orthogonal()
	if d_to_parent > orbitMaxRange or d_to_parent < orbitMinRange:
		var s = 1 if d_to_parent < orbitMinRange else -1
		moveVector = moveVector + vectorToParent * s
		
	return (moveVector*speed)


func chase_player():
	return ((player.position - position).normalized() * speed)


func recieve_damage(_damage):
	queue_free()
	if parent != null:
		parent.minions.erase(self)


var arrow_mode : String = "none"

func _draw_vector(vec : Vector2, pos : Vector2):
	const l : float = 10
	var arr : PackedVector2Array = [
		pos,
		pos+vec,
	]
	arr.append(arr[1])
	arr.append(arr[1] + vec.rotated(deg_to_rad(135)).normalized()*l)

	arr.append(arr[1])
	arr.append(arr[1] + vec.rotated(deg_to_rad(-135)).normalized()*l)
	var color : Color = Color.BLACK
	match arrow_mode:
		"follow":
			color = Color.BLUE
		"chase":
			color = Color.RED
		"none":
			color = Color.WHITE
	draw_multiline(arr, color)





