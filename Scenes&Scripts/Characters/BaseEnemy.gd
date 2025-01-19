extends CharacterBody2D

signal dead
const kill_points= preload("res://Scenes&Scripts/UI/Score.tscn")

var player : CharacterBody2D

@export var enemySpeed: int
@export var acceleration: int;
@export var deceleration: int;
var velocity : Vector2
var health : int = 8
var myHealthBar : TextureProgressBar
var gun : Node
@export (float) var bulletSpawnDistance : float
@export var attackInterval: float 
var attackIntervalCounter : float
@export var breakTime: float 
var breakTimeCounter : float
var enemyType : int


var gunDropPath : String;
@export var healthDropChance: float = 0.3

var tween : Tween


func _ready():
	connect("dead", Callable(GlobalReferences.sceneRoot.get_node("UI/Control/ScoreCounter"), "UpdateScore"))
	tween = GlobalReferences.tween
	GlobalReferences.sceneRoot.enemiesInLevel.append(self)
	player = GlobalReferences.player
	attackIntervalCounter = attackInterval
	breakTimeCounter = 1
	var healthbarNode : Node2D = load(GlobalReferences.healthbarPath).instantiate()
	healthbarNode.myOwner = self
	myHealthBar = healthbarNode.get_node("TextureProgressBar")
	healthbarNode.position = position
	myHealthBar.max_value = health
	myHealthBar.value = health
	add_child(healthbarNode)
	


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
		
		attackIntervalCounter -=delta
	
	breakTimeCounter -=delta



func recieve_damage(damage):
	health -= damage
	tween.interpolate_property(myHealthBar, "value", myHealthBar.value, health, 0.2)
	if not tween.is_active():
		tween.start()
	if health <= 0:
		emit_signal("dead") #signal for updatescore
		#plays the score animation
		var kill_points_instance = kill_points.instance()
		kill_points_instance.global_position = global_position
		GlobalReferences.sceneRoot.add_child(kill_points_instance)
		
		queue_free()
		$DeathSound.play()
		drop_gun()
		try_drop_health()
		GlobalReferences.sceneRoot.enemiesInLevel.erase(self)





func drop_gun():
	var newGunDrop : Node2D = load(gunDropPath).instantiate();
	
	
	newGunDrop.position = position
	var angle : float = GlobalReferences.randNoGen.randf_range(0, 2*PI)
	newGunDrop.directionVector = Vector2(cos(angle), sin(angle))
	GlobalReferences.sceneRoot.call_deferred("add_child", newGunDrop)





func try_drop_health():
	var e = GlobalReferences.randNoGen.randf()
	if e < healthDropChance:
		var healthPickup : Node2D = load(GlobalReferences.healthPickupPath).instantiate()
		healthPickup.position = position
		var angle : float = GlobalReferences.randNoGen.randf_range(0, 2*PI)
		healthPickup.directionVector = Vector2(cos(angle), sin(angle))
		GlobalReferences.sceneRoot.call_deferred("add_child", healthPickup)











