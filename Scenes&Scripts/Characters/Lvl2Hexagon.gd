extends Hexagon
class_name Lvl2Hexagon

## In addition to level 1 behaviour, the hexagon will stop to spawn minions, then resume its normal behaviour.[br]
## The spawned minions will orbit it and start moving towards the player if it gets too close to the minions.
## When the hexagon dies all its minions start following the player.

var creatingMinions : bool = false
var minionSpawnTime : float
var minionSpawnTimeCounter : float
var minionSpawnNumber : int = 3
var minionsCreated : int = 0
var minionSpawnRange : float = 50
var minionScene : PackedScene = load(GlobalReferences.minionPath)
var minions : Array = []
var maxMinions : int = 6


func _ready():
	super._ready()
	minionSpawnTime = (breakTime * 0.7) / minionSpawnNumber
	minionSpawnTimeCounter = minionSpawnTime


func _process(delta):
	super._process(delta)
	if creatingMinions:
		if minions.size() >= maxMinions:
			creatingMinions = false
			return
		
		if minionSpawnTimeCounter <= 0:
			create_minion()
			minionSpawnTimeCounter = minionSpawnTime
		minionSpawnTimeCounter -= delta
		if minionsCreated >= minionSpawnNumber:
			creatingMinions = false
			minionsCreated = 0
		


func handle_movement(delta):
	if not GlobalReferences.playerExists:
		return
	look_at(player.position)
	if creatingMinions:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
		move_and_slide()
		return

	var moveVector = (player.position - position).orthogonal().normalized() *pow(-1, int(clockwiseMove)) + (player.position - position).normalized()*0.5
	var dFromPlayer : float = (position - player.position).length()
	if dFromPlayer >= maxRange:
		moveVector += (player.position - position).normalized()

	velocity = velocity.move_toward(moveVector*max_speed, acceleration * delta)
	move_and_slide()


func handle_shooting(delta):
	if not GlobalReferences.playerExists:
		return
	
	breakTimeCounter -=delta
	if breakTimeCounter <= 0:
		gun.shoot(player.position)
		attackIntervalCounter -=delta
		if attackIntervalCounter <= 0:
			breakTimeCounter = breakTime
			attackIntervalCounter = attackInterval
			clockwiseMove = not clockwiseMove
			creatingMinions = true
		

func create_minion():
	var randNoGen = RandomNumberGenerator.new()
	var spawnAngle : float = randNoGen.randf_range(0, 2*PI)
	var spawnVector : Vector2 = position + Vector2(cos(spawnAngle), sin(spawnAngle)) * minionSpawnRange
	var minion : CharacterBody2D = minionScene.instantiate()
	minion.position = spawnVector
	minion.parent = self
	GlobalReferences.sceneRoot.add_child(minion)
	minionsCreated += 1
	minions.append(minion)
	


func recieve_damage(damage):
	super.recieve_damage(damage)
	
	if health <= 0:
		for m in minions:
			m.parent = null
		


