extends Node2D


var enemiesInLevel : Array
var score : int = 0

@export var TLCorner : Vector2
@export var BRCorner : Vector2

func _init():
	GlobalReferences.randNoGen = RandomNumberGenerator.new()
	GlobalReferences.sceneRoot = self


func _ready():
	
	randomize()
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

