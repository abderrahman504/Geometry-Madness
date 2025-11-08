extends CharacterBody2D
class_name BaseEnemy


var player : CharacterBody2D

# public stats
@export var max_speed: int = 50
@export var max_health: int = 8
var health : int

# private stats
@export var attackInterval: float = 2 ## The period of time this enemy attacks for before taking a break
var attackIntervalCounter : float
@export var breakTime: float = 5 ## The time this enemy takes between two attack intervals
var breakTimeCounter : float
@export var healthDropChance: float = 0.3 ## The chance of this enemy dropping a health drop


var healthbarNode: Node2D
var myHealthBar : TextureProgressBar
@export var gun : Node
var bulletSpawnDistance : float: 
	get: 
		return $BulletSpawnPos.position.length() 
var enemyType : int
var gunDropPath : String;
var tween : Tween



func _ready():
	GlobalReferences.sceneRoot.enemiesInLevel.append(self)
	player = GlobalReferences.player
	attackIntervalCounter = attackInterval
	breakTimeCounter = 1
	health = max_health
	# Create a heathbar and add it to the world scene
	healthbarNode = load(GlobalReferences.healthbarPath).instantiate()
	myHealthBar = healthbarNode.get_node("TextureProgressBar")
	healthbarNode.myOwner = self
	myHealthBar.max_value = max_health
	myHealthBar.value = health
	GlobalReferences.sceneRoot.add_child.call_deferred(healthbarNode)


func _process(delta):
	handle_shooting(delta)


func _physics_process(delta):
	handle_movement(delta)


func handle_movement(_delta):
	pass


func handle_shooting(delta):
	if not GlobalReferences.playerExists:
		return
	
	if breakTimeCounter <= 0:
		gun.shoot(player.position)
		if attackIntervalCounter <= 0:
			breakTimeCounter = breakTime
			attackIntervalCounter = attackInterval
		
		attackIntervalCounter -= delta
	
	breakTimeCounter -= delta


func recieve_damage(damage):
	health -= damage
	if tween != null:
		tween.kill()
	tween = create_tween()
	tween.tween_property(myHealthBar, "value", health, 0.2)
	if health <= 0:
		die()
		


## Runs logic related to enemy death
func die():
	# the enemy_died signal calls a function that updates the score
	EnemySignalBus.enemy_died.emit(self)
	queue_free()
	# I don't think the sound will play if this node is freed.
	$DeathSound.play()
	# Dropping the enemy gun and possible health drop
	drop_gun()
	try_drop_health()


func drop_gun():
	var newGunDrop : Node2D = load(gunDropPath).instantiate();
	newGunDrop.position = position
	var randNoGen = RandomNumberGenerator.new()
	var angle : float = randNoGen.randf_range(0, 2*PI)
	newGunDrop.directionVector = Vector2.from_angle(angle)
	GlobalReferences.sceneRoot.call_deferred("add_child", newGunDrop)


func try_drop_health():
	var randNoGen = RandomNumberGenerator.new()
	var e = randNoGen.randf()
	if e < healthDropChance:
		var healthPickup : Node2D = load(GlobalReferences.healthPickupPath).instantiate()
		healthPickup.position = position
		var angle : float = randNoGen.randf_range(0, 2*PI)
		healthPickup.directionVector = Vector2(cos(angle), sin(angle))
		GlobalReferences.sceneRoot.call_deferred("add_child", healthPickup)

