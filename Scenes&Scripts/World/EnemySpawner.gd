extends Node2D
class_name EnemySpawner


@export_group("Enemies")
## The enemies that are spawned during the first lvl of the game
@export var lvl1_enemies : Array[PackedScene]
## The enemies that are spawned during the second lvl of the game
@export var lvl2_enemies : Array[PackedScene]


@export_group("Spawn Limits")
## The amount of time to wait since the level started to begin spawning enemies.
@export var start_break_time: float = 4
## The base amount of time between two enemy spawns.
## The actual amount of time is extended/reduced based on the number of alive enemies.
@export var base_enemy_spawn_time: float
## The maximum number of enemies that can be in the level at once.
@export var maxNumberOfEnemies: int = 10
var _spawned_enemies_count : int = 0

var _adjusted_enemy_spawn_time : float:
	get:
		return base_enemy_spawn_time * (1 + spawnDelayFactor * (float(_spawned_enemies_count) / maxNumberOfEnemies))

var enemy_spawn_timer : float
## Positive values extend spawning time. negative values reduce it.
@export var spawnDelayFactor: float = 2
@onready var pathFollow : PathFollow2D = $Path2D/PathFollow2D

var lvl : int = 1

func _process(delta):
	start_break_time -= delta
	if start_break_time > 0:
		return
	
	if _spawned_enemies_count >= maxNumberOfEnemies:
		return
	

	#Counting down until the next enemy spawn
	enemy_spawn_timer -= delta
	if enemy_spawn_timer <= 0:
		spawn_random_enemy()
		enemy_spawn_timer = _adjusted_enemy_spawn_time


func spawn_random_enemy() -> void:
	var scenes = lvl1_enemies if lvl == 1 else lvl2_enemies
	var enemy : BaseEnemy = scenes[randi_range(0, scenes.size()-1)].instantiate()
	pathFollow.progress_ratio = randf()
	enemy.position = pathFollow.global_position
	enemy.died.connect(_on_spawned_enemy_died)
	GlobalReferences.sceneRoot.get_node("Enemies").add_child(enemy)
	_spawned_enemies_count += 1


func _on_spawned_enemy_died() -> void:
	_spawned_enemies_count -= 1
