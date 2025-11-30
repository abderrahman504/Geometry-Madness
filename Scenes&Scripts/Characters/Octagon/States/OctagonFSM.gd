extends HierarchicalStateMachine
class_name OctagonFSM


@export var character : BaseEnemy
		

## The distance the octagon wants to be from the player before entering defense mode.
@export var player_dist_threshold : float = 350



func _ready():
	start()
	$Defense.teleported.connect(_on_teleported)
	$Defense.character = character
	$Active.character = character


func _process(delta):
	super._process(delta)
	if not GlobalReferences.playerExists:
		return
	
	match current.name:
		"Active":
			_process_active(delta)
		
		"Defense":
			_process_defense(delta)


func _process_active(delta : float) -> void:
	if GlobalReferences.player.position.distance_to(character.position) <= player_dist_threshold:
		current = $Defense


func _process_defense(delta : float) -> void:
	pass


func _on_teleported() -> void:
	current = $Active
	
