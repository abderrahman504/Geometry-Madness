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



func enter() -> void:
	print("Defense entered")
	charge_timer = 0
	charge_bar.show()
	charge_bar.max_value = 100
	charge_bar.value = 0


func exit() -> void:
	charge_bar.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta : float) -> void:
	print("Defense update")
	if charge_timer >= teleport_charge_time:
		teleport()
	charge_timer += delta
	charge_bar.value = 100 * (teleport_charge_time - charge_timer) / teleport_charge_time


func teleport() -> void:
	## Locate possible destinations
	var floors: PackedVector2Array = GlobalReferences.level_tilemap.get_floor_tiles()
	var valid_positions : PackedVector2Array = []
	for tile in floors:
		var pos : Vector2 = GlobalReferences.level_tilemap.get_global_tile_pos(tile)
		if (not GlobalReferences.playerExists):
			valid_positions.append(pos)
		elif ((pos - GlobalReferences.player.global_position).length() >= min_distance_to_player and 
		(pos - character.global_position).length() >= min_teleport_distance
		):
			valid_positions.append(pos)

	## Pick a random destination
	var rand := randi_range(0, valid_positions.size() - 1)
	var dest := valid_positions[rand]

	## Teleport 
	var vfx = teleport_effect.instantiate()
	vfx.global_position = character.global_position
	vfx.rotation = (dest - character.global_position).angle()
	GlobalReferences.sceneRoot.add_child(vfx)
	character.global_position = dest

	teleported.emit()
