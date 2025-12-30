extends World

@onready var square_spawn_pos : Vector2 = $SquareSpawnPosition.position

@onready var tutorial_panel : TutorialText = $CanvasLayer/TutorialText

var octagon_killed := false
var square_killed := false
var pickup1_picked := false
var pickup2_picked := false
var moved := false
var looked := false

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	$Octagon/HierarchicalStateMachine.stop()


func _on_player_moved() -> void:
	if tutorial_panel._stage != TutorialText.START:
		return
	moved = true
	if looked:
		tutorial_panel.next_stage()


func _on_player_looked() -> void:
	if tutorial_panel._stage != TutorialText.START:
		return
	looked = true
	if moved:
		tutorial_panel.next_stage()


func _on_player_shot(_angle : float, _gun : BaseGun) -> void:
	if tutorial_panel._stage == TutorialText.SHOOT:
		tutorial_panel.next_stage()


func _on_gun_picked_up() -> void:
	if pickup2_picked:
		return
	elif pickup1_picked:
		pickup2_picked = true
		$EnemySpawner.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		pickup1_picked = true
		_spawn_square()
	tutorial_panel.next_stage()


func _on_square_died():
	tutorial_panel.next_stage()


func _on_octagon_died():
	tutorial_panel.next_stage()


func _spawn_square() -> void:
	$Square.position = square_spawn_pos
	$Square.process_mode = Node.PROCESS_MODE_INHERIT
