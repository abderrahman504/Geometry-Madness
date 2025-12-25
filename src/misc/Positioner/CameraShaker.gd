extends Shaker
class_name CameraShaker

var base_min_frequency : float = 1
var base_max_frequency : float = 5
var base_min_amplitude : int = 5
var base_max_amplitude : int = 20
var base_min_duration : float = 0.2
var base_max_duration : float = 0.6
var min_frequency : float
var max_frequency : float
var min_amplitude : int
var max_amplitude : int
var min_duration : float
var max_duration : float

var min_str : float = 0
var max_str : float = 4

var shake_intensity : float


func _ready() -> void:
	var shake_intensity : float = SettingsManager.get_attribute("Camera Shake Intensity")
	if shake_intensity == null:
		shake_intensity = 0.5
	_update_shake_intensity(shake_intensity)

	SettingsManager.attribute_updated.connect(func(attr: String, value): if attr == "Camera Shake Intensity": _update_shake_intensity(value))



func _on_player_shot_fired(angle : float, gun : BaseGun) -> void:
	if is_zero_approx(shake_intensity): return
	var direction := -1 * Vector2.from_angle(angle)
	var strength_measure = 0.7 * gun.bulletDamage * 0.3 * gun.pellet_count
	var ss := smoothstep(min_str, max_str, strength_measure)
	duration = min_duration + ss * (max_duration - min_duration)
	frequency = min_frequency + ss * (max_frequency - min_frequency)
	dist = min_amplitude + ss * (max_amplitude - min_amplitude)
	shake(direction)
	

func _update_shake_intensity(shake_intensity : float) -> void:
	self.shake_intensity = shake_intensity
	# This reshaping makes the intensity grow quickly towards 1. Checkout the graph for (x-1)^3 + 1 in the range [0,1]
	var intensity_reshaped = pow(shake_intensity-1, 3) + 1
	min_amplitude = base_min_amplitude * intensity_reshaped
	max_amplitude = base_max_amplitude * intensity_reshaped
	min_frequency = base_min_frequency * intensity_reshaped
	max_frequency = base_max_frequency * intensity_reshaped
	min_duration = base_min_duration * intensity_reshaped
	max_duration = base_max_duration * intensity_reshaped
