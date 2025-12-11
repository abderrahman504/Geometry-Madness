extends State

## This state triggers a short teleport to avoid incoming bullets.

var character : BaseEnemy

signal short_teleport_used


@export var min_teleport_range : float = 100
@export var max_teleport_range : float = 300
@export var teleport_effect : PackedScene

var _detected_bullets : Dictionary



func _physics_update(delta : float) -> void:
	super._physics_update(delta)

	# Check for bullets that need to be dodged
	var cumulative_dodge_vector := Vector2.ZERO
	for bullet in _detected_bullets.values():
		## Check if bullet path will go through character 
		var bullet_to_character : Vector2 = character.position - bullet.position
		var bullet_move_vec : Vector2 = (bullet as Bullet).velocity
		const angle_to_dodge_threshold := 30.0
		if abs(bullet_to_character.angle_to(bullet_move_vec)) < angle_to_dodge_threshold:
			# Must dodge
			cumulative_dodge_vector += get_dodge_vector(bullet)
	if not cumulative_dodge_vector.is_zero_approx():
		_dodge_teleport(cumulative_dodge_vector.normalized())



		

## Returns the recommended dodge vector to avoid the bullet.
func get_dodge_vector(bullet : Bullet) -> Vector2:
	
	var character_to_bullet : Vector2 = bullet.position - character.position
	var bullet_move_vec : Vector2 = bullet.velocity.normalized()
	var bullet_approach_angle : float = asin(bullet_move_vec.cross(character_to_bullet) / character_to_bullet.length())
	if bullet_approach_angle == 0:
		bullet_approach_angle = 1
	
	return Vector2(-bullet_move_vec.y, bullet_move_vec.x).normalized() * sign(bullet_approach_angle)



func _dodge_teleport(dodge_vector : Vector2) -> void:
	dodge_vector = dodge_vector * ((max_teleport_range - min_teleport_range) * randf() + min_teleport_range)
	# Check if there is a wall in the way of the dodge teleport
	# First attempt
	var query := PhysicsRayQueryParameters2D.create(
		character.global_position, 
		character.global_position + dodge_vector,
		4
	)
	var res := character.get_world_2d().direct_space_state.intersect_ray(query)
	if not res.is_empty():
		dodge_vector *= -1

	# Second attempt
	query.to = character.global_position + dodge_vector
	res = character.get_world_2d().direct_space_state.intersect_ray(query)
	if not res.is_empty():
		dodge_vector = dodge_vector.orthogonal()
	
	# Last attempt
	query.to = character.global_position + dodge_vector
	res = character.get_world_2d().direct_space_state.intersect_ray(query)
	if not res.is_empty():
		dodge_vector *= -1
	


	# Perform short teleport
	var vfx = teleport_effect.instantiate()
	vfx.global_position = character.global_position
	vfx.rotation = dodge_vector.angle()
	GlobalReferences.sceneRoot.add_child(vfx)
	character.global_position += dodge_vector

	short_teleport_used.emit()


func _on_body_detected(body : Node2D) -> void:
	if body is Bullet:
		_detected_bullets[body.get_instance_id()] = body
	else:
		push_warning("Octagon bullet detection area has detected a non-bullet body")


func _on_body_lost(body : Node2D) -> void:
	_detected_bullets.erase(body.get_instance_id())

