extends Node2D
class_name World


## When this score is passed, the game will transition to level 2.
@export var transition_score : int = 3000

var score : int = 0
var tweened_score : int = 0
var tween : Tween
var lvl : int = 1

@export var TLCorner : Vector2
@export var BRCorner : Vector2
@onready var music_player : MusicPlayer = $MusicPlayer


func _init():
	GlobalReferences.sceneRoot = self


func _ready():
	EnemySignalBus.enemy_died.connect(on_enemy_died)
	$Player.died.connect(_on_player_died)
	music_player.switch_to_track(music_player.music_tracks[0])


func transition():
	if lvl == 2:
		return
	lvl += 1
	var spawner : EnemySpawner = $EnemySpawner
	spawner.lvl = lvl
	# Change music
	music_player.switch_to_track(music_player.music_tracks[lvl-1])



func on_enemy_died(enemy: BaseEnemy):
	# Update the score
	score += enemy.score_value
	if tween != null:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "tweened_score", score, 0.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	if score >= transition_score:
		transition()


func _on_player_died() -> void:
	music_player.switch_to_track(null)
	var deathMenu = load(GlobalReferences.DeathMenu).instantiate()
	GlobalReferences.game_ui.add_child(deathMenu)
	GlobalReferences.sceneRoot.get_node("DeathSound").play()
