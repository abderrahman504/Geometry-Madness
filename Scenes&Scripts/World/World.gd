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
@onready var scoreboard : Control = $CanvasLayer/Scoreboard

@export_group("Moving Score Object")
@export var moving_score_obj_scene : PackedScene
@export var score_marker_control : Control


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
	if enemy.score_value == 0:
		return
	
	# Update the score
	score += enemy.score_value

	# Create moving score label
	var moving_score : Node2D = moving_score_obj_scene.instantiate()
	moving_score.global_position = enemy.global_position
	moving_score.get_node("Label").text = str(enemy.score_value)
	moving_score.get_node("PositionManager/FollowControl").followed= score_marker_control
	
	add_child(moving_score)
	moving_score.get_node("PositionManager/EaserIn").destination_reached.connect(tween_score)
	moving_score.get_node("PositionManager/EaserIn").destination_reached.connect(func(): moving_score.queue_free())
	
	if score >= transition_score:
		transition()



func _on_player_died() -> void:
	music_player.switch_to_track(null)
	show_scoreboard()
	$DeathSound.play()


func show_scoreboard() -> void:
	scoreboard.show()
	scoreboard.get_node("Labels/Score").text = str(score)
	scoreboard.get_node("Labels/HighScore").text = "High Score : " + str(ScoreStorage.high_score)
	scoreboard.get_node("Labels/NewRecord").hide()
	# implement later : read high score and check if new score is higher or not 
	if score > ScoreStorage.high_score:
		scoreboard.get_node("Labels/NewRecord").show()
		ScoreStorage.high_score = score
		ScoreStorage.save_high_score()
	

func tween_score() -> void:
	if tween != null:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "tweened_score", score, 0.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)


func _on_restart_pressed():
	get_tree().change_scene_to_file(GlobalReferences.main_level_scene)


func _on_main_menu_pressed():
	get_tree().change_scene_to_file(GlobalReferences.main_menu_scene)
