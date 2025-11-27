extends State
class_name Refinement

## A refinement is a state machine within a state machine. The refinement is considered to be a state by the higher level SM.


@export var entry : State

var current : State:
	get:
		return current
	set(state):
		if current != null:
			current.exit()
		current = state
		state.enter()


func enter() -> void:
	current = entry


func exit() -> void:
	pass


func update(delta : float) -> void:
	if current != null:
		current.update(delta)


func physics_update(delta : float) -> void:
	if current != null:
		current.physics_update(delta)