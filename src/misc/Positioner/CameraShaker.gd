extends Shaker
class_name CameraShaker

var min_frequency : float = 1
var max_frequency : float = 3
var min_amplitude : int = 5
var max_amplitude : int = 15
var min_duration : float = 0.2
var max_duration : float = 0.4

var min_str : float = 0
var max_str : float = 10


func _on_player_shot_fired(angle : float, gun : BaseGun) -> void:
	var direction := -1 * Vector2.from_angle(angle)
	var strength_measure = gun.bulletDamage * gun.pellet_count
	var ss := smoothstep(min_str, max_str, strength_measure)
	duration = min_duration + ss * (max_duration - min_duration)
	frequency = min_frequency + ss * (max_frequency - min_frequency)
	dist = min_amplitude + ss * (max_amplitude - min_amplitude)
	shake(direction)
	
