extends CharacterBody2D
class_name BaseEnemy


signal died

var player : CharacterBody2D


@export var gun : Node
@export var enemyType : GlobalReferences.COLOURS
## The score gained by killing this enemy
@export var score_value : int = 100;
var tween : Tween

# public stats
@export_group("Stats")
@export var max_speed: int = 50
@export var max_health: int = 8
var health : float

# private stats
@export var attackInterval: float = 2 ## The period of time this enemy attacks for before taking a break
var attackIntervalCounter : float
@export var breakTime: float = 5 ## The time this enemy takes between two attack intervals
var breakTimeCounter : float


var healthbarNode: Node2D
var myHealthBar : TextureProgressBar
var bulletSpawnDistance : float: 
	get: 
		return $BulletSpawnPos.position.length() 

@export_group("Drops")
@export var gunDropScene : PackedScene;
@export var healthDropChance: float = 0.3 ## The chance of this enemy dropping a health drop

@export_group("VFX")
@export var particle_texture : Texture2D
@export var death_vfx_scene : PackedScene
@export var hit_vfx_scene : PackedScene



func _ready():
	player = GlobalReferences.player

	var difficulty_mods := {
		1 : 0.6,
		2 : 0.8,
		3 : 1.0,
		4 : 1.2,
		5 : 1.4,
	}
	max_health *= difficulty_mods[GlobalReferences.difficulty]	
	
	attackIntervalCounter = attackInterval
	breakTimeCounter = 1
	health = max_health
	# Create a heathbar and add it to the world scene
	healthbarNode = load(GlobalReferences.healthbarPath).instantiate()
	myHealthBar = healthbarNode.get_node("TextureProgressBar")
	gun.user = self
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


func recieve_damage(damage : float, impact_pos : Vector2):
	if health <= 0:
		return
	health -= damage
	if tween != null:
		tween.kill()
	tween = create_tween()
	tween.tween_property(myHealthBar, "value", health, 0.2)
	if health <= 0:
		die()
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
		


## Runs logic related to enemy death
func die():
	# the enemy_died signal calls a function that updates the score
	EnemySignalBus.enemy_died.emit(self)
	died.emit()
	queue_free()
	$DeathSound.play()
	# Create death effect
	if death_vfx_scene != null:
		var death_effect = death_vfx_scene.instantiate()
		var particles : GPUParticles2D = death_effect.get_node("GPUParticles2D")
		particles.texture = particle_texture
		particles.modulate = $Sprite2D.modulate
		death_effect.position = position
		GlobalReferences.sceneRoot.add_child(death_effect)
	# Dropping the enemy gun and possible health drop
	drop_gun()
	try_drop_health()


func drop_gun():
	var newGunDrop : Node2D = gunDropScene.instantiate();
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

