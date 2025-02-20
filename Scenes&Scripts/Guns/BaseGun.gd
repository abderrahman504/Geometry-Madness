extends Node

@export var fireRate: float
@export var bulletDamage: int
var bulletLifeTime : float = 5
var bulletScaleFactor : float = 1
var bulletSpeedFactor : float = 1
var maxAmmo : int = 180
var ammoCount : int = maxAmmo
@export var ammoConsumption: int
var piercingBullets : bool = false
var splittingBullets : bool = false
var shootingAngles : Array

var gunType : int
var user : CharacterBody2D
var cooldown : float;
var bulletScene : PackedScene = load(GlobalReferences.bullet)
var bullet : Area2D





func shoot(target : Vector2):
	
	if cooldown > 0:
		return
	
	var gunAngle : float = (target - user.position).angle()
	for angle in shootingAngles:
		bullet = bulletScene.instantiate()
		var shootingVector : Vector2 = Vector2(cos(angle+gunAngle),sin(angle+gunAngle)) * user.bulletSpawnDistance
		bullet.position = user.position + shootingVector
		bullet.rotation = gunAngle + angle
		bullet.direction = shootingVector.normalized()
		#changing the bullet collision mask depending on who fired it
		# All bullets already detect walls
		if user == GlobalReferences.player:
			bullet.collision_layer = 8
			bullet.collision_mask += 2 # Detect enemy layer
			for record in GlobalReferences.colourToGunMap:
				if record["gun"] == gunType:
					bullet.colour_bullet(record["colour"], record["colour"])
					break
		else:
			bullet.collision_layer = 16
			bullet.collision_mask += 1 # Detect player layer
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
		if gunType != GlobalReferences.GUNTYPES.Pistol:
			GlobalReferences.game_ui.ammo_bars.update_ammo_bar()
		if ammoCount <= 0:
			queue_free()
			GlobalReferences.game_ui.ammo_bars.gun1 = null
			GlobalReferences.player.gun1 = null
			GlobalReferences.player.gun = GlobalReferences.player.pistolGun
	
	cooldown = 1/fireRate



func _process(delta):
	cooldown -= delta;
