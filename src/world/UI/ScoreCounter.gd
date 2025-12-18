extends Label
class_name ScoreCounter


func _process(_delta):
	text = "Score: " + str(GlobalReferences.sceneRoot.tweened_score)

