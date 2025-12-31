extends CharacterBody2D
class_name Player

signal died
## Emitted when the player shoots.
signal shot_fired(angle : float, gun : BaseGun)
signal looked
signal moved
signal gun_picked

@export var cursor : Sprite2D
@export var cursor_max_distance : float = 100
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

@export_group("VFX")
@export var particle_texture : Texture2D
@export var death_vfx_scene : PackedScene
@export var hit_vfx_scene : PackedScene

func _init():
	GlobalReferences.player = self


func _ready():
	GlobalReferences.playerExists = true
	
	# Adjusting max health based on difficulty
	var difficulty_mods := {
		1 : 1.6, 
		2 : 1.3,
		3: 1, 
		4 : 0.7,
		5 : 0.4,
	}
	maxHealth *= difficulty_mods[GlobalReferences.difficulty]

	# Creating the player health bar
	health = maxHealth
	healthbar_node = load(GlobalReferences.healthbarPath).instantiate()
	myHealthBar = healthbar_node.get_node("TextureProgressBar")
	healthbar_node.myOwner = self
	myHealthBar.max_value = maxHealth
	myHealthBar.value = health
	GlobalReferences.sceneRoot.add_child.call_deferred(healthbar_node)
	# Initializing base gun
	gun = base_gun
	base_gun.user = self
	base_gun.fired.connect(_on_gun_fired)
	
	InputDeviceTracker.device_changed.connect(_on_input_device_changed)
	_on_input_device_changed(InputDeviceTracker.current_device)


func _process(_delta):
	#If the lmb is pressed, the gun will try to shoot - if the gun cool down is 0 then it will shoot
	if Input.is_action_pressed("LMB"):
		gun.shoot(cursor.global_position)


func _physics_process(delta):
	# In case of controller then move cursor based on look input
	if InputDeviceTracker.current_device != InputDeviceTracker.Device.KEYBOARD:
		var look_vec : Vector2 = Input.get_vector("look left", "look right", "look up", "look down")
		look_vec *= cursor_max_distance
		# Clamp a zero vector
		if look_vec == Vector2.ZERO:
			look_vec = Vector2.from_angle(rotation) * 0.2 * cursor_max_distance
		else:
			looked.emit()
		cursor.global_position = position + look_vec
	
	elif Input.get_last_mouse_velocity().length_squared() > 1:
		looked.emit()
	# This block of code is for Movement and Rotation
	look_at(cursor.global_position)
	inputVector = Input.get_vector("left", "right", "up", "down")
	if InputDeviceTracker.current_device == InputDeviceTracker.Device.KEYBOARD:
		inputVector = inputVector.normalized()
	if inputVector != Vector2.ZERO:
		moved.emit()
		velocity = velocity.move_toward(inputVector*maxSpeed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	
	move_and_slide()


func recieve_damage(damage: float, impact_pos : Vector2):
	health -= damage
	$HitSound.play()
	if tween != null:
		tween.kill()
	tween = create_tween()
	tween.tween_property(myHealthBar, "value", health, 0.2)
	if health <= 0:
		queue_free()
		GlobalReferences.playerExists = false
		died.emit()
		# Create death effect
		if death_vfx_scene != null:
			var death_effect = death_vfx_scene.instantiate()
			var particles : GPUParticles2D = death_effect.get_node("GPUParticles2D")
			particles.texture = particle_texture
			particles.modulate = $Sprite2D.modulate
			death_effect.position = position
			GlobalReferences.sceneRoot.add_child(death_effect)
	else:
		# Create hit effect
		var hit_effect = hit_vfx_scene.instantiate()
		var particles : GPUParticles2D = hit_effect.get_node("GPUParticles2D")
		particles.texture = particle_texture
		particles.modulate = $Sprite2D.modulate
		particles.amount = ceili(2 * damage)
		var explosion_dir := (impact_pos - position).normalized()

		hit_effect.position = impact_pos
		hit_effect.rotation = explosion_dir.angle()
		GlobalReferences.sceneRoot.add_child(hit_effect)


func heal(amount : float) -> void:
	$HealthPickupSound.play()
	health = min(maxHealth, health + amount)
	if tween != null:
		tween.kill()
	tween = create_tween()
	tween.tween_property(myHealthBar, "value", health, 0.2)


func get_new_gun(gunPickupType : int):
	$GunPickupSound.play()
	gun_picked.emit()
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
	newGun.fired.connect(_on_gun_fired)
	
	
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
	mixedGun.fired.connect(_on_gun_fired)



func _on_gun_fired() -> void:
	$ShootSound.play()
	shot_fired.emit(rotation, gun)


func _on_input_device_changed(device : InputDeviceTracker.Device) -> void:
	var is_keyboard := device == InputDeviceTracker.Device.KEYBOARD
	cursor.get_node("PositionManager").process_mode = Node.PROCESS_MODE_INHERIT if is_keyboard else PROCESS_MODE_DISABLED
	GlobalReferences.sceneRoot.get_node("Camera2D/PositionManager").process_mode = Node.PROCESS_MODE_INHERIT if is_keyboard else PROCESS_MODE_DISABLED
	GlobalReferences.sceneRoot.get_node("Camera2D/JoypadPositionManager").process_mode = Node.PROCESS_MODE_INHERIT if not is_keyboard else PROCESS_MODE_DISABLED
	
