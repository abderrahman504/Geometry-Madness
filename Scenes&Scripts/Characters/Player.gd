extends CharacterBody2D
class_name Player

signal died

@export var maxSpeed: float
@export var acceleration: float
@export var deceleration: float
@export var maxHealth: int
var health : float
var healthbar_node : Node2D
var myHealthBar : TextureProgressBar
## The main gun used by the player.
var gun : BaseGun
## In case the mixed gun is the current gun, then this is one of the guns being mixed.
var gun1 : BaseGun
## In case the mixed gun is the current gun, then this is one of the guns being mixed.
var gun2 : BaseGun

var inputVector : Vector2
var bulletSpawnDistance : float:
	get:
		return $BulletSpawnPos.position.length()

## The gun the player goes back to when he runs out of ammo.
@export var base_gun : BaseGun
var tween : Tween

func _init():
	GlobalReferences.player = self


func _ready():
	GlobalReferences.playerExists = true
	#Creating the player health bar
	health = maxHealth
	healthbar_node = load(GlobalReferences.healthbarPath).instantiate()
	myHealthBar = healthbar_node.get_node("TextureProgressBar")
	healthbar_node.myOwner = self
	myHealthBar.max_value = maxHealth
	myHealthBar.value = health
	GlobalReferences.sceneRoot.add_child.call_deferred(healthbar_node)
	gun = base_gun
	base_gun.user = self



func _process(_delta):
	#If the lmb is pressed, the gun will try to shoot - if the gun cool down is 0 then it will shoot
	if Input.is_action_pressed("LMB"):
		gun.shoot(get_global_mouse_position())


func _physics_process(delta):
	#This block of code is for Movement and Rotation
	look_at(get_global_mouse_position())
	inputVector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	inputVector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	inputVector = inputVector.normalized()
	if inputVector != Vector2.ZERO:
		velocity = velocity.move_toward(inputVector*maxSpeed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	
	move_and_slide()


func recieve_damage(damage: float, impact_pos : Vector2):
	health -= damage
	if tween != null:
		tween.kill()
	tween = create_tween()
	tween.tween_property(myHealthBar, "value", health, 0.2)
	if health <= 0:
		queue_free()
		GlobalReferences.playerExists = false
		died.emit()


func heal(amount : float) -> void:
	health = min(maxHealth, health + amount)
	if tween != null:
		tween.kill()
	tween = create_tween()
	tween.tween_property(myHealthBar, "value", health, 0.2)


func get_new_gun(gunPickupType : int):
	
	if gun.gunType == gunPickupType:
		gun.ammoCount = gun.maxAmmo
		return
	
	if gun.gunType == GlobalReferences.GUNTYPES.Mixed:
		
		if gunPickupType == gun1.gunType:
			gun1.ammoCount = gun1.maxAmmo
			return
		
		elif gunPickupType == gun2.gunType:
			gun2.ammoCount = gun2.maxAmmo
			return
		
		gun2.queue_free() #Deletes the older of the two guns
		gun.queue_free() #Delete the old mixed gun
	
	var newGun : Node = load(GlobalReferences.GunPaths[gunPickupType]).instantiate()
	
	newGun.user = self
	
	
	if gun == base_gun:
		gun1 = newGun
		gun = newGun
		add_child(newGun)
		return
	
	
	gun2 = gun1
	gun1 = newGun
	add_child(newGun)
	var mixedGun = load(GlobalReferences.GunPaths[GlobalReferences.GUNTYPES.Mixed]).instantiate()
	mixedGun.user = self
	mixedGun.parent1 = gun1
	mixedGun.parent2 = gun2
	gun = mixedGun
	add_child(gun)
	

