extends Node2D
class_name BasePickup

#Spawn variables.
var directionVector : Vector2;
var velocity : Vector2;
var speed : float = 350;
var deceleration : float = 500;


@export var pickUpRange : float = 150;
@export var lifeSpan : float = 8;
@export var fadeTime : float = 5;
@export var fadeSpeed : float = 250;
var increasingAlpha : bool = false;
var beingPickedUp : bool = false;



func _ready():
	velocity = directionVector * speed


func _process(delta):
	if not GlobalReferences.playerExists:
		return
	var player = GlobalReferences.player
	position += velocity * delta
	velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	var distanceFromPlayer = (position - player.position).length()
	if distanceFromPlayer <= pickUpRange and not beingPickedUp:
		get_picked_up()
	
	lifeSpan -= delta
	if lifeSpan <= fadeTime:
		run_fade_effect(delta);
	
	if lifeSpan <= 0:
		queue_free()



func run_fade_effect(delta):
	if increasingAlpha:
		modulate.a8 += fadeSpeed * delta;
		if modulate.a8 >= 255:
			increasingAlpha = false;
	else:
		modulate.a8 -= fadeSpeed * delta;
		if modulate.a8 <= 0:
			increasingAlpha = true;
	

func get_picked_up():
	beingPickedUp = true
	var tween : Tween = create_tween()
	tween.tween_property(self, "position", GlobalReferences.player.position, 0.1) # Tween nodes are useful for animating properties in code, here we animate the position of the pick up to the player position
	tween.finished.connect(move_to_player_finished)
	
	


func move_to_player_finished():
	if GlobalReferences.playerExists:
		run_pickup_effect()
	queue_free()


func run_pickup_effect(): #This funcion will be specified for each different type of pickup
	pass


