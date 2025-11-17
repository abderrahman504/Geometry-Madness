@tool
class_name KeepOnScreen
extends Control


## This node helps maintain its parent control on screen while keeping it as close as possible to its original position.
## When changing the position of the parent node is desired, be sure to change [code]_original_position[/code] as well.


@export var _active : bool = true

## The original position of the parent node
var _original_position : Vector2
## The adjusted position of the parent node to keep it on screen.
var _adjusted_positon : Vector2:
	get:
		return _adjusted_positon
	set(value):
		_adjusted_positon = value
		get_parent().position = value


func _ready() -> void:
	var parent = get_parent()
	if parent is Control:
		_original_position = parent.position
		_adjusted_positon = _original_position


func _process(delta : float) -> void:
	if Engine.is_editor_hint():
		update_configuration_warnings()
	else:
		if _active:
			_update()


func _update() -> void:
	var parent : Control = get_parent()
	# If parent position was moved externally
	if parent.position != _adjusted_positon:
		# Update original position
		_original_position = parent.position
	
	# Reset parent to original position before adjusting
	_adjusted_positon = _original_position

	var view_rect : Rect2 = Rect2(get_viewport_transform().origin * -1, get_viewport_rect().size)
	var parent_rect : Rect2 = Rect2(parent.global_position, parent.size)

	if view_rect.encloses(parent_rect):
		return

	# Need to adjust the parent position

	# determine position to place parent
	var glob_adjusted_position : Vector2 = parent_rect.position
	glob_adjusted_position = glob_adjusted_position.clamp(view_rect.position, view_rect.end - parent_rect.size)
	
	parent.global_position = glob_adjusted_position
	_adjusted_positon = parent.position




func set_active(value : bool) -> void:
	if value == false:

		get_parent().position = _original_position
	


func _get_configuration_warnings() -> PackedStringArray:
	var arr := PackedStringArray()

	if get_parent() is Control:
		return arr
	arr.append("Parent node must be Control for this node to work correctly.")
	return arr 
