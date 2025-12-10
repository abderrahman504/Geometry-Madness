extends BaseGun
class_name MixedGun

var parent1 : BaseGun
var parent2 : BaseGun



func _init():
	gunType = GlobalReferences.GUNTYPES.Mixed



func _ready():
	fireRate = (parent1.fireRate+parent2.fireRate) / 2
	spread = (parent1.spread + parent2.spread) / 2
	pellet_count = max(parent1.pellet_count, parent2.pellet_count)

	bulletDamage = (parent1.bulletDamage+parent2.bulletDamage)/2
	bulletLifeTime = (parent1.bulletLifeTime + parent2.bulletLifeTime)/2
	bulletScaleFactor = (parent1.bulletScaleFactor + parent2.bulletScaleFactor)/2
	bulletSpeedFactor = (parent1.bulletSpeedFactor + parent2.bulletSpeedFactor)/2
	speed_variance = (parent1.speed_variance + parent2.speed_variance) / 2
	piercingBullets = parent1.piercingBullets or parent2.piercingBullets
	splittingBullets = parent1.splittingBullets or parent2.splittingBullets


func shoot(target):
	if cooldown > 0:
		return
	var gunAngle : float = (target - user.position).angle()
	for i in range(pellet_count):
		var bullet : Bullet = _create_bullet(gunAngle)
		if user == GlobalReferences.player:
			bullet.collision_layer |= 128 # Place bullet in player bullets layer
			bullet.collision_mask |= 2 # Detect enemy layer
			var gunColours : Vector2i = Vector2i.ZERO
			for record in GlobalReferences.colourToGunMap:
				if record["gun"] == parent1.gunType:
					gunColours.x = record["colour"];
				
				elif record["gun"] == parent2.gunType:
					gunColours.y = record["colour"];
			
			bullet.colour_bullet(gunColours.x, gunColours.y);
		else:
			bullet.collision_layer |= 64 # Place bullet in enemy bullets layer
			bullet.collision_mask |= 1 # Detect player layer
		
		
		bullet.mixed = true
		
		
	#Handling ammo consumption and deleting the gun when it runs out of ammo
	if not parent1.infinite_ammo:
		parent1.ammoCount -= 1
	if not parent2.infinite_ammo:
		parent2.ammoCount -= 1

	
	if parent1.ammoCount <= 0:
		print("Gun 1 ran out of ammo")
		GlobalReferences.player.gun1 = parent2
		GlobalReferences.player.gun = parent2
		parent1.queue_free()
		parent1 = null
	
	if parent2.ammoCount <= 0:
		print("Gun 2 ran out of ammo")
		GlobalReferences.player.gun = parent1
		parent2.queue_free()
		parent2 = null
	
	if parent1 == null or parent2 == null:
		print("Mixed gun ran out of ammo")
		GlobalReferences.player.gun2 = null
		queue_free()
		if parent1 == null and parent2 == null:
			GlobalReferences.player.gun = GlobalReferences.player.base_gun
		
	cooldown = 1/fireRate
	fired.emit()






