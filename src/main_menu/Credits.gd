extends Panel

@export var scroll_speed : float = 20

@onready var container : Control = $Container
# Called when the node enters the scene tree for the first time.
func _ready():
	container.position = $Start.position - Vector2(0.5 * container.size.x, 0);

func _process(delta : float) -> void:
	if container.position.y <= $End.position.y - container.size.y:
		exit()
	else:
		container.position.y -= scroll_speed * delta


func _input(event : InputEvent) -> void:
	if (
		(event is InputEventKey or
		event is InputEventJoypadButton or 
		event is InputEventMouseButton) and 
		event.pressed == false):
		exit()


func exit() -> void:
	get_tree().change_scene_to_file(GlobalReferences.main_menu_scene)
