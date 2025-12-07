extends Node
class_name BaseGun


@export var gunType : GlobalReferences.GUNTYPES

@export var fireRate: float
## The maximum angle(degrees) away from the gun center that a bullet may be shot at.
@export var spread : float = 0
## A curve describing the probability distribution for the spread of pellets. If this is null then a uniform distribution is used
@export var spread_distribution : Curve
## How many bullets are shot.
@export var pellet_count : int = 1
@export var maxAmmo : int = 10
@export var infinite_ammo : bool = false
@onready var ammoCount : int = maxAmmo
#@export var ammoConsumption: int

@export_category("Bullet Properties")

## A variance applied to the bullet velocity when spawned.
@export_range(0, 0.5) var speed_variance : float = 0
@export var bulletDamage: float = 1
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
	
	var gunAngle := (target - user.position).angle()
	for i in range(pellet_count):
		var bullet := _create_bullet(gunAngle)
		# Set bullet color and collision layers/masks
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
	
	
	if user == GlobalReferences.player:
		if not infinite_ammo:
			ammoCount -= 1
		if ammoCount <= 0:
			queue_free()
			GlobalReferences.player.gun1 = null
			GlobalReferences.player.gun = GlobalReferences.player.base_gun
	
	cooldown = 1/fireRate



func _create_bullet(gun_angle : float) -> Bullet:
	var bullet : Bullet = bulletScene.instantiate()
	var shoot_angle : float
	if spread_distribution == null:
		shoot_angle = gun_angle + randf_range(-1 * spread, spread) * (PI / 180.0)
	else:
		var rand := randf_range(-1, 1)
		shoot_angle = gun_angle + sign(rand) * spread_distribution.sample_baked(abs(rand)) * (PI/180.0)
	var shootingVector : Vector2 = Vector2.from_angle(shoot_angle) * user.bulletSpawnDistance
	bullet.position = user.position + shootingVector
	bullet.rotation = shoot_angle
	bullet.direction = shootingVector.normalized()
	bullet.speed = bullet.speed * (1 + randf_range(-1 * speed_variance, speed_variance))
		
	bullet.splitting = splittingBullets
	bullet.piercing = piercingBullets
	bullet.scale *= bulletScaleFactor
	bullet.scaleFactor = bulletScaleFactor
	bullet.speed *= bulletSpeedFactor
	bullet.bulletDespawnTime = bulletLifeTime
	bullet.damage = bulletDamage
	GlobalReferences.sceneRoot.add_child(bullet)
	return bullet


func _process(delta):
	cooldown -= delta;
