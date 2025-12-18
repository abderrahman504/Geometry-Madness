extends Panel

@export var scroll_speed : float = 20
@export var main_scene : PackedScene

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
	if event is InputEventKey:
		exit()


func exit() -> void:
	get_tree().change_scene_to_packed(main_scene)
