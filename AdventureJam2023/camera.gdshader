shader_type canvas_item;

uniform sampler2D stuff:hint_screen_texture;
void fragment() {
	vec4 col = texture(stuff, UV);
	COLOR = col;
}
