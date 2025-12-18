shader_type canvas_item;

uniform float min_alpha : hint_range(0., 1.) = 0.5;
uniform float gradient_length_norm : hint_range(0.,0.5) = 0.1;
uniform float gradient_length_pixels : hint_range(0, 2024, 1.) = 10;
uniform bool use_norm_len = true;
uniform vec2 rect_size;
uniform bool ignore_text = true;

void fragment() {
	if (!ignore_text || TEXTURE_PIXEL_SIZE != vec2(1./256.)){
		vec2 gradient_length = use_norm_len ? vec2(gradient_length_norm) : (1./rect_size * gradient_length_pixels);
		vec2 alpha = (1. - (1.-min_alpha) * smoothstep(vec2(0.), gradient_length, UV) + 
		(1.-min_alpha) * smoothstep(1.-gradient_length, vec2(1.), UV));
		//COLOR.a = max(alpha.x, alpha.y);
		COLOR.a *= max(alpha.x, alpha.y);
	}
}
