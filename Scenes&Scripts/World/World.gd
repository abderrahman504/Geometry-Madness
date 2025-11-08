extends Node2D
class_name World


const kill_points= preload("res://Scenes&Scripts/UI/Score.tscn")

@export var transition_score : int = 3000
@export var transition_scene : PackedScene

var enemiesInLevel : Array
var score : int = 0
var tweened_score : int = 0
var tween : Tween

@export var TLCorner : Vector2
@export var BRCorner : Vector2


func _init():
	GlobalReferences.sceneRoot = self


func _ready():
	EnemySignalBus.enemy_died.connect(on_enemy_died)
	$BackgroundMusic.play()


var doNotPause : bool = false

func _unhandled_input(event):
	if event.is_action_pressed("Escape"):
		if doNotPause:
			doNotPause = false
			return
		
		get_tree().paused = true
		$UI/PauseMenu.show()


func transition():
	if (transition_scene == null): return
	var transitionAnimation = load(GlobalReferences.Level2Transition).instantiate()
	transitionAnimation.animation_finished.connect(on_transition_animation_finished)
	get_tree().paused = true
	transitionAnimation.position = GlobalReferences.sceneRoot.get_node("Camera2D").position
	GlobalReferences.sceneRoot.add_child(transitionAnimation)


func on_transition_animation_finished():
	get_tree().paused = false
	get_tree().change_scene_to_packed(transition_scene)


func on_enemy_died(enemy: BaseEnemy):
	enemiesInLevel.erase(enemy)
	# Update the score
	score += 100
	if tween != null:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "tweened_score", score, 0.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	if score >= transition_score:
		transition()
