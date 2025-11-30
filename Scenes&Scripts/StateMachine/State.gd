extends Node
class_name State

## A state can itself be a state machine if [code]entry[/code] is set to another state.

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


## Called by the managing [code]StateMachine[/code] or [code]State[/code] to indicate that this state has been entered.
func _enter() -> void:
	current = entry


## Called by the managing [code]StateMachine[/code] or [code]State[/code] to indicate that this state has been exited.
func _exit() -> void:
	current = null


## Called by the managing [code]StateMachine[/code] or [code]State[/code] once every idle frame while the state is entered.
func _update(delta : float) -> void:
	if current != null:
		current._update(delta)


## Called by the managing [code]StateMachine[/code] or [code]State[/code] once every physics frame while the state is entered.
func _physics_update(delta : float) -> void:
	if current != null:
		current._physics_update(delta)
