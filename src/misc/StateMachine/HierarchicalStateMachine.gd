extends Node
class_name HierarchicalStateMachine


@export var entry : State

var current : State:
	get:
		return current
	set(state):
		if current != null:
			current._exit()
		current = state
		if state != null:
			state._enter()


func start() -> void:
	current = entry


func stop() -> void:
	current = null


func _process(delta) -> void:
	if current != null:
		current._update(delta)


func _physics_process(delta) -> void:
	if current != null:
		current._physics_update(delta)
