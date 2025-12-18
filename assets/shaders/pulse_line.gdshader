shader_type canvas_item;

uniform float pulse_w = 0.1;
uniform float pulse_duration : hint_range(1, 100, 1) = 2;
uniform vec4 default_color : source_color = vec4(1.);
uniform vec4 pulse_color : source_color = vec4(0.5);
uniform float transparency_length : hint_range (0., 1.) = 0.1;
varying vec4 base_color;

// Plots the value x as a horizonral band on the texture 
vec4 plot_float(float x, float min_x, float max_x, vec2 uv, vec4 plot_color)
{
	float norm_x = (x - min_x) / (max_x - min_x);
	return (1.-smoothstep(0., 0.01, abs(uv.x - norm_x))) * plot_color;
}


void vertex(){
	base_color = COLOR;
}

void fragment() {
	// Create pulse
	float pulse_pos = fract(TIME / pulse_duration);
	pulse_pos = pulse_pos * (1. + 2.*pulse_w) - pulse_w;
	float dist_to_pulse = abs(UV.x - pulse_pos);
	float dist_norm = (dist_to_pulse) / pulse_w;
	float perc = clamp(0., 1., 1.-dist_norm);
//	COLOR = default_color;
	vec4 new_color = mix(default_color, pulse_color, perc);
	COLOR *= new_color;
	
}
