extends Node
class_name PositionManager


## If true, the manager will update the position of the target during the physics frame instead of the idle frame.
@export var physics_based : bool = false

## The node whose position is managed by this class.
@export var target : Node2D:
	set(val):
		target = val
		for positioner in _positioner_chain:
			positioner.target = val

## The chain of positioner nodes 
@export var _positioner_chain : Array[Positioner]

func _ready() -> void:
	for positioner in _positioner_chain:
		positioner.target = target

func _physics_process(delta) -> void:
	var pos : Vector2 = target.position
	for poser in _positioner_chain:
		pos = poser.get_desired_position(pos, delta)
	
	target.position = pos
