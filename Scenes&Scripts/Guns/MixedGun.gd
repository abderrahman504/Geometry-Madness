extends BaseGun
class_name MixedGun

var parent1 : BaseGun
var parent2 : BaseGun



func _init():
	gunType = GlobalReferences.GUNTYPES.Mixed



func _ready():
	shootingAngles = [0]
	bulletDamage = (parent1.bulletDamage+parent2.bulletDamage)/2
	fireRate = (parent1.fireRate+parent2.fireRate)/2
	bulletLifeTime = (parent1.bulletLifeTime + parent2.bulletLifeTime)/2
	bulletSpeedFactor = (parent1.bulletSpeedFactor + parent2.bulletSpeedFactor)/2
	bulletScaleFactor = (parent1.bulletScaleFactor + parent2.bulletScaleFactor)/2
	piercingBullets = parent1.piercingBullets or parent2.piercingBullets
	splittingBullets = parent1.splittingBullets or parent2.splittingBullets


func shoot(target):
	if cooldown > 0:
		return
	var bullet : Area2D
	var gunAngle : float = (target - user.position).angle()
	for angle in shootingAngles:
		bullet = bulletScene.instantiate()
		var shootingVector : Vector2 = Vector2.from_angle(angle+gunAngle) * user.bulletSpawnDistance
		bullet.position = user.position + shootingVector
		bullet.rotation = gunAngle + angle
		bullet.direction = shootingVector.normalized()
		#changing the bullet collision mask depending on who fired it
		if user == GlobalReferences.player:
			bullet.collision_layer |= 128 # Place bullet in player bullets layer
			bullet.collision_mask |= 2 # Detect enemy layer
			var gunColours : Vector2 = Vector2.ZERO
			for record in GlobalReferences.colourToGunMap:
				if record["gun"] == parent1.gunType:
					gunColours.x = record["colour"];
				
				elif record["gun"] == parent2.gunType:
					gunColours.y = record["colour"];
			
			bullet.colour_bullet(gunColours.x, gunColours.y);
		else:
			bullet.collision_layer |= 64 # Place bullet in enemy bullets layer
			bullet.collision_mask |= 1 # Detect player layer
		
		bullet.splitting = splittingBullets
		bullet.piercing = piercingBullets
		bullet.scale *= bulletScaleFactor
		bullet.scaleFactor = bulletScaleFactor
		bullet.speed *= bulletSpeedFactor
		bullet.bulletDespawnTime = bulletLifeTime
		bullet.damage = bulletDamage
		bullet.mixed = true
		GlobalReferences.sceneRoot.add_child(bullet)
		
		
		#Handling ammo consumption and deleting the gun when it runs out of ammo
		parent1.ammoCount -= parent1.ammoConsumption
		parent2.ammoCount -= parent2.ammoConsumption
		GlobalReferences.game_ui.ammo_bars.update_mixed_ammo_bar()
		
		if parent1.ammoCount <= 0:
			GlobalReferences.player.gun1 = parent2
			GlobalReferences.player.gun = parent2
			GlobalReferences.game_ui.ammo_bars.gun1 = parent2
			parent1.queue_free()
			parent1 = null
		
		if parent2.ammoCount <= 0:
			GlobalReferences.player.gun = parent1
			parent2.queue_free()
			parent2 = null
		
		if parent1 == null or parent2 == null:
			GlobalReferences.player.gun2 = null
			queue_free()
			if parent1 == null and parent2 == null:
				GlobalReferences.player.gun = GlobalReferences.player.pistolGun
		
		
		
		cooldown = 1/fireRate






