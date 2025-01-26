extends Node2D
class_name World


const kill_points= preload("res://Scenes&Scripts/UI/Score.tscn")

var enemiesInLevel : Array
var score : int = 0

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


func move_to_level2():
	var transitionAnimation = load(GlobalReferences.Level2Transition).instantiate()
	get_tree().paused = true
	transitionAnimation.position = GlobalReferences.sceneRoot.get_node("Camera2D").position
	GlobalReferences.sceneRoot.add_child(transitionAnimation)


func on_enemy_died(enemy: BaseEnemy):
	pass
	# Update score
	# Plays the score animation
	#var kill_points_instance = kill_points.instantiate()
	#kill_points_instance.global_position = enemy.global_position
	#add_child(kill_points_instance)
