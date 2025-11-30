extends State
class_name ActiveState


var character : BaseEnemy


## The number of minions spawned every second while the octagon is in the active state.
@export var minion_spawn_rate : float
## The minion that gets spawned by this enemy during the active state.
@export var minion_scene : PackedScene

@export var minion_spawn_marker : Node2D

var minion_spawn_distance : float:
	get: return minion_spawn_marker.position.length()


var minion_spawn_timer : float
var minion_spawn_time : float:
	get: return 1.0 / minion_spawn_rate


func _enter() -> void:
	super._enter()
	minion_spawn_timer = 0


func _update(delta : float) -> void:
	super._update(delta)
	character.handle_shooting(delta)
	if minion_spawn_timer >= minion_spawn_time:
		_spawn_minion()
		minion_spawn_timer -= minion_spawn_time
	minion_spawn_timer += delta


func _spawn_minion() -> void:
	var minion : CharacterBody2D = minion_scene.instantiate()
	
	minion.position = character.position + Vector2.from_angle(randf()) * minion_spawn_distance
	GlobalReferences.sceneRoot.add_child(minion)
