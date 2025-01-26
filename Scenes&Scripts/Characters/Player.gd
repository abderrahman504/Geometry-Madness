extends CharacterBody2D

@export var maxSpeed: float
@export var acceleration: float
@export var deceleration: float
@export var maxHealth: int
var health : int
var healthbar_node : Node2D
var myHealthBar : TextureProgressBar
var gun : Node
var gun1 : Node
var gun2 : Node
var inputVector : Vector2
var bulletSpawnDistance : float = 25 #How far the bullet will spawn away from the player


var pistolGun : Node
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
	#spawning the pistol weapon for the player
	pistolGun = load(GlobalReferences.GunPaths["pistol"]).instantiate()
	pistolGun.user = self
	gun = pistolGun
	add_child(pistolGun)



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


func recieve_damage(damage):
	health -= damage
	if tween != null:
		tween.kill()
	tween = create_tween()
	tween.tween_property(myHealthBar, "value", health, 0.2)
	if health <= 0:
		GlobalReferences.sceneRoot.get_node("DeathSound").play()
		queue_free()
		GlobalReferences.playerExists = false
		var deathMenu = load(GlobalReferences.DeathMenu).instantiate()
		GlobalReferences.sceneRoot.get_node("UI").add_child(deathMenu)


func get_new_gun(gunPickupType : int):
	
	if gun.gunType == gunPickupType:
		gun.ammoCount = gun.maxAmmo
		GlobalReferences.game_ui.ammo_bars.update_ammo_bar()
		return
	
	if gun.gunType == GlobalReferences.GUNTYPES.Mixed:
		
		if gunPickupType == gun1.gunType:
			gun1.ammoCount = gun1.maxAmmo
			GlobalReferences.game_ui.ammo_bars.update_mixed_ammo_bar()
			return
		
		elif gunPickupType == gun2.gunType:
			gun2.ammoCount = gun2.maxAmmo
			GlobalReferences.game_ui.ammo_bars.update_mixed_ammo_bar()
			return
		
		gun2.queue_free() #Deletes the older of the two guns
		gun.queue_free() #Delete the old mixed gun
	
	var newGun : Node
	if gunPickupType == GlobalReferences.GUNTYPES.Machinegun:
		newGun = load(GlobalReferences.GunPaths["machinegun"]).instantiate()
	elif gunPickupType == GlobalReferences.GUNTYPES.Shotgun:
		newGun = load(GlobalReferences.GunPaths["shotgun"]).instantiate()
	elif gunPickupType == GlobalReferences.GUNTYPES.SplitRifle:
		newGun = load(GlobalReferences.GunPaths["split rifle"]).instantiate()
	elif gunPickupType == GlobalReferences.GUNTYPES.HeavyCanon:
		newGun = load(GlobalReferences.GunPaths["heavy canon"]).instantiate()
	
	newGun.user = self
	
	
	if gun == pistolGun:
		gun1 = newGun
		gun = newGun
		GlobalReferences.game_ui.ammo_bars.gun1 = gun1
		GlobalReferences.game_ui.ammo_bars.update_ammo_bar()
		add_child(newGun)
		return
	
	
	gun2 = gun1
	gun1 = newGun
	add_child(newGun)
	var mixedGun = load(GlobalReferences.GunPaths["mixed gun"]).instantiate()
	mixedGun.user = self
	mixedGun.parent1 = gun1
	mixedGun.parent2 = gun2
	gun = mixedGun
	GlobalReferences.game_ui.ammo_bars.gun1 = gun1
	GlobalReferences.game_ui.ammo_bars.gun2 = gun2
	GlobalReferences.game_ui.ammo_bars.update_mixed_ammo_bar()
	add_child(gun)
	




