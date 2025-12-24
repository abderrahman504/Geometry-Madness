extends Shaker
class_name CameraShaker

var min_frequency : float = 1
var max_frequency : float = 5
var min_amplitude : int = 5
var max_amplitude : int = 20
var min_duration : float = 0.2
var max_duration : float = 0.6

var min_str : float = 0
var max_str : float = 4

var shake_intensity


func _ready() -> void:
	shake_intensity = SettingsManager.get_attribute("Camera Shake Intensity")
	if shake_intensity == null:
		shake_intensity = 0.5
	# This reshaping makes the intensity grow quickly towards 1. Checkout the graph for (x-1)^3 + 1 in the range [0,1]
	var intensity_reshaped = pow(shake_intensity-1, 3) + 1
	min_amplitude *= intensity_reshaped
	max_amplitude *= intensity_reshaped
	min_frequency *= intensity_reshaped
	max_frequency *= intensity_reshaped
	min_duration *= intensity_reshaped
	max_duration *= intensity_reshaped


func _on_player_shot_fired(angle : float, gun : BaseGun) -> void:
	if is_zero_approx(shake_intensity): return
	var direction := -1 * Vector2.from_angle(angle)
	var strength_measure = 0.7 * gun.bulletDamage * 0.3 * gun.pellet_count
	var ss := smoothstep(min_str, max_str, strength_measure)
	duration = min_duration + ss * (max_duration - min_duration)
	frequency = min_frequency + ss * (max_frequency - min_frequency)
	dist = min_amplitude + ss * (max_amplitude - min_amplitude)
	shake(direction)
	
