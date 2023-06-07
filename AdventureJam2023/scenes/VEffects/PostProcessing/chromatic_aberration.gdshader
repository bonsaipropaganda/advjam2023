shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;

uniform float sharpness = 5.0;
uniform vec2 emphasis = vec2(0.0, 0.3);

uniform float red_displacement   = 0.0;
uniform float green_displacement = 0.008;
uniform float blue_displacement  = 0.01;

void fragment() {
	vec2 centered_uv = (UV - 0.5) * 2.0;
	
	float effect = max(pow(abs(centered_uv.x), 1.0 - emphasis.x), pow(abs(centered_uv.y), 1.0 - emphasis.y));
	effect = pow(effect, sharpness);
	effect = clamp(effect, 0.0, 1.0);
	
	COLOR.r = textureLod(screen_texture, UV + centered_uv * effect * red_displacement  , 0.0).r;
	COLOR.g = textureLod(screen_texture, UV + centered_uv * effect * green_displacement, 0.0).g;
	COLOR.b = textureLod(screen_texture, UV + centered_uv * effect * blue_displacement , 0.0).b;
}
