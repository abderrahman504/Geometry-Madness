extends State
class_name DefenseState

signal teleported

var character : BaseEnemy


## Teleportation will try to move the character at least this distance.
@export var min_teleport_distance : float = 100
## Teleportation will try to keep at least this distance between the character and the player.
@export var min_distance_to_player : float = 200
@export var charge_bar : TextureProgressBar
@export var teleport_effect : PackedScene

var charge_timer : float

## The time it takes to fully charge the teleport
@export var teleport_charge_time : float


## The number of minions spawned every second while the octagon is in the active state.
@export var minion_spawn_rate : float
## The maximum number of minions active at once
@export var max_minions : int = 5
## The number of alive minions
var _alive_minions : int = 0
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
	charge_timer = 0
	charge_bar.show()
	charge_bar.max_value = 100
	charge_bar.value = 0
	minion_spawn_timer = minion_spawn_time


func _exit() -> void:
	super._exit()
	charge_bar.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _update(delta : float) -> void:
	super._update(delta)
	if charge_timer >= teleport_charge_time:
		teleport()
	charge_timer += delta
	charge_bar.value = 100 * charge_timer / teleport_charge_time
	
	if minion_spawn_timer >= minion_spawn_time and _alive_minions < max_minions:
		_spawn_minion()
		minion_spawn_timer = 0
		_alive_minions += 1
	minion_spawn_timer += delta


## Teleports the character to a position approp
func teleport() -> void:
	## Locate possible destinations
	var floors: PackedVector2Array = GlobalReferences.level_tilemap.get_floor_tiles()
	var valid_positions : PackedVector2Array = []
	for tile in floors:
		var pos : Vector2 = GlobalReferences.level_tilemap.get_global_tile_pos(tile) + 0.5 * GlobalReferences.level_tilemap.get_global_tile_size()
		if (not GlobalReferences.playerExists):
			valid_positions.append(pos)
		elif ((pos - GlobalReferences.player.global_position).length() >= min_distance_to_player and 
		(pos - character.global_position).length() >= min_teleport_distance
		):
			valid_positions.append(pos)

	## Pick a random destination
	if valid_positions.is_empty():
		printerr("teleport() could not find any valid positions!")
		return
	var rand := randi_range(0, valid_positions.size() - 1)
	var dest := valid_positions[rand]

	## Teleport 
	var vfx = teleport_effect.instantiate()
	vfx.global_position = character.global_position
	vfx.rotation = (dest - character.global_position).angle()
	GlobalReferences.sceneRoot.add_child(vfx)
	character.global_position = dest

	teleported.emit()


func _spawn_minion() -> void:
	var minion : CharacterBody2D = minion_scene.instantiate()
	
	minion.position = character.position + Vector2.from_angle(randf()) * minion_spawn_distance
	minion.died.connect(_on_minion_died)
	GlobalReferences.sceneRoot.add_child(minion)


func _on_minion_died() -> void:
	_alive_minions -= 1
