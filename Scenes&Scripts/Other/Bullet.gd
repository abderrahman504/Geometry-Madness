extends Area2D
class_name Bullet


@export var speed : float = 400
var direction : Vector2
var velocity : Vector2
var bulletDespawnTime : float = 5
var timeToEnableCollision : float = 0.1
var damage : float
var damageBoostFactor : float = 2
var mixedDamageBoostFactor : float = 1.5
var mixed : bool = false
var splitting : bool = false
var piercing : bool = false
var scaleFactor : float = 1

var innerTint : int = GlobalReferences.COLOURS.Grey
var outerTint : int = GlobalReferences.COLOURS.Grey
var shatterTint : Color = Color("666666")


func _ready():
	velocity = direction * speed


func _process(delta):
	position += velocity * delta
	bulletDespawnTime -= delta
	if bulletDespawnTime <= 0:
		queue_free()
		var shatterEffect = load(GlobalReferences.shatterEffect).instantiate()
		shatterEffect.scale *= scaleFactor
		shatterEffect.position = position
		shatterEffect.modulate = shatterTint
		GlobalReferences.sceneRoot.add_child(shatterEffect)
		if splitting:
			split()
	
	if $CollisionShape2D.disabled:
		timeToEnableCollision -=delta
		if timeToEnableCollision <= 0:
			$CollisionShape2D.disabled = false


func _on_Bullet_body_entered(body):
	
	var destroyEffect : Sprite2D
	
	if body is CharacterBody2D:
		var appliedDamage : float = damage
		if body != GlobalReferences.player: #If bullet hit an enemy
			if body.enemyType == innerTint or body.enemyType == outerTint: #If the enemy colour is the same as either of the bullet's colours
				appliedDamage = int(mixed)*(damage * mixedDamageBoostFactor)+int(not mixed)*(damage * damageBoostFactor)
		
		body.recieve_damage(appliedDamage)
		destroyEffect = load(GlobalReferences.hitEffect).instantiate()
	else:
		destroyEffect = load(GlobalReferences.shatterEffect).instantiate()
		destroyEffect.scale *= scaleFactor
		destroyEffect.modulate = shatterTint
	
	
	destroyEffect.position = position
	GlobalReferences.sceneRoot.add_child(destroyEffect)
	
	if splitting:
		split()
	
	
	if piercing and (body is CharacterBody2D):
		return
	queue_free()


func split():
	var bulletScene : PackedScene = load(GlobalReferences.bullet)
	var root : Node2D = get_parent()
#	var bulletAngle : float = atan2(direction.y, direction.x)
	for i in range(4):
		var newAngle = (PI/4) + i*(PI/2) #+ bulletAngle
		var newDirection = Vector2(cos(newAngle), sin(newAngle))
		var newBullet : Area2D = bulletScene.instantiate()
		newBullet.direction = newDirection
		newBullet.position = position + newDirection * 20
		newBullet.rotation = newAngle
		newBullet.speed = speed
		newBullet.scale *= 0.75
		newBullet.damage = 1
		newBullet.bulletDespawnTime = 2
		newBullet.collision_mask = collision_mask
		newBullet.colour_bullet(innerTint, outerTint)
		root.call_deferred("add_child", newBullet)


func colour_bullet(Inner: int, Outer: int):
	innerTint = Inner
	outerTint = Outer
	$Outer.modulate = GlobalReferences.colours[Outer]
	$Inner.modulate = GlobalReferences.colours[Inner]


