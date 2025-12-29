extends CharacterBody2D
class_name BasePickup

#Spawn variables.
var directionVector : Vector2;
var speed : float = 350;
var deceleration : float = 500;


@export var pickUpRange : float = 150;
@export var lifeSpan : float = 8;
@export var fadeTime : float = 5;
@export var fadeSpeed : float = 250;
var increasingAlpha : bool = false;
var beingPickedUp : bool = false;
var _life_timer : float = 0


func _ready():
	velocity = directionVector * speed


func _process(delta):
	if not GlobalReferences.playerExists:
		return
	var player = GlobalReferences.player
	
	move_and_slide()
	velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	var distanceFromPlayer = (position - player.position).length()
	if distanceFromPlayer <= pickUpRange and not beingPickedUp:
		get_picked_up()
	
	_life_timer += delta
	if _life_timer >= lifeSpan - fadeTime:
		run_fade_effect(delta);
	
	if _life_timer >= lifeSpan:
		queue_free()



func run_fade_effect(delta : float) -> void:
	var _fade_timer = _life_timer - (lifeSpan - fadeTime)
	_fade_timer = max(_fade_timer, 0)
	modulate.a = abs(cos(_fade_timer * 2*PI / (fadeTime * 0.8)))
	

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


