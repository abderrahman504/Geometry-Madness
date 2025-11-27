extends Node
class_name HierarchicalStateMachine


@export var entry : State

var current : State:
	get:
		return current
	set(state):
		if current != null:
			current.exit()
		current = state
		if state != null:
			state.enter()


func start() -> void:
	current = entry


func stop() -> void:
	current = null


func _process(delta) -> void:
	if current != null:
		current.update(delta)


func _physics_process(delta) -> void:
	if current != null:
		current.physics_update(delta)
