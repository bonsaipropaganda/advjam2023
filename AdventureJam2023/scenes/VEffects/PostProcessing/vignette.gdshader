shader_type canvas_item;

uniform vec3 color: source_color = vec3(0.0);
uniform float strength = 0.3;
uniform float y_emphasis = 1.4;

void fragment() {
	float vignette = abs(UV.x * pow(UV.y, y_emphasis) * (1.0 - UV.x) * pow(1.0 - UV.y, y_emphasis) * 18.0);
	vignette = pow(vignette, strength);
	
	COLOR.rgb = color;
	COLOR.a = 1.0 - vignette;
}
