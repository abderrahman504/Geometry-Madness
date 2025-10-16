extends Node
class_name BaseGun


@export var gunType : GlobalReferences.GUNTYPES

@export var fireRate: float
## The maximum angle(degrees) away from the gun center that a bullet may be shot at.
@export var spread : float = 0
## How many bullets are shot.
@export var pellet_count : int = 1
var maxAmmo : int = 180
var ammoCount : int = maxAmmo
@export var ammoConsumption: int

@export_category("Bullet Properties")

@export var bulletDamage: int
@export var bulletLifeTime : float = 5
@export var bulletScaleFactor : float = 1
@export var bulletSpeedFactor : float = 1
## Whether bullets pierce targets or get destroyed on impact
@export var piercingBullets : bool = false
## Whether bullets split and spawn smaller bullets when destroyed or not.
@export var splittingBullets : bool = false


var user : CharacterBody2D
var cooldown : float;
var bulletScene : PackedScene = load(GlobalReferences.bullet)


func shoot(target : Vector2):
	if cooldown > 0:
		return
	
	var bullet : Area2D
	var gunAngle := (target - user.position).angle()
	for i in range(pellet_count):
		bullet = bulletScene.instantiate()
		var shoot_angle :=  gunAngle + randf_range(-1 * spread, spread) * (PI / 180.0)
		var shootingVector : Vector2 = Vector2.from_angle(shoot_angle) * user.bulletSpawnDistance
		bullet.position = user.position + shootingVector
		bullet.rotation = shoot_angle
		bullet.direction = shootingVector.normalized()
		#changing the bullet collision mask depending on who fired it
		# All bullets already detect walls
		if user == GlobalReferences.player:
			bullet.collision_layer |= 128 # Place bullet in player bullets layer
			bullet.collision_mask |= 2 # Detect enemy layer
			for record in GlobalReferences.colourToGunMap:
				if record["gun"] == gunType:
					bullet.colour_bullet(record["colour"], record["colour"])
					break
		else:
			bullet.collision_layer |= 64 # Place bullet in enemy bullets layer
			bullet.collision_mask |= 1 # Detect player layer
			bullet.colour_bullet(GlobalReferences.COLOURS.Orange, GlobalReferences.COLOURS.Orange)
			bullet.shatterTint = GlobalReferences.colours[GlobalReferences.COLOURS.Orange]
			
		bullet.splitting = splittingBullets
		bullet.piercing = piercingBullets
		bullet.scale *= bulletScaleFactor
		bullet.scaleFactor = bulletScaleFactor
		bullet.speed *= bulletSpeedFactor
		bullet.bulletDespawnTime = bulletLifeTime
		bullet.damage = bulletDamage
		GlobalReferences.sceneRoot.add_child(bullet)
	
	
	if user == GlobalReferences.player:
		ammoCount -= ammoConsumption
		if ammoCount <= 0:
			queue_free()
			GlobalReferences.player.gun1 = null
			GlobalReferences.player.gun = GlobalReferences.player.pistolGun
	
	cooldown = 1/fireRate



func _process(delta):
	cooldown -= delta;
