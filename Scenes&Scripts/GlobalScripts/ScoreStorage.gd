extends Node
# Singleton script

## Reads the high score data locally and stores it.


var high_score : int = 0
var file_path : String = "user://score.dat" 


# Called when the node enters the scene tree for the first time.
func _ready():
	_read_high_score()


func _read_high_score() -> void:
	var fh : FileAccess = FileAccess.open(file_path, FileAccess.READ)
	if fh == null:
		return
	high_score = int(fh.get_as_text())


func save_high_score() -> void:
	var fh : FileAccess = FileAccess.open(file_path, FileAccess.WRITE)
	fh.store_string(str(high_score))
