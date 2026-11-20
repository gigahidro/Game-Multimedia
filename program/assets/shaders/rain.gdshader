shader_type canvas_item;

uniform float speed : hint_range(0.5, 15.0) = 4.5;
uniform float slant : hint_range(-1.0, 1.0) = -0.06;
uniform float density : hint_range(0.1, 2.0) = 1.0;

void fragment() {
	vec2 uv = UV;
	uv.y = fract(uv.y - TIME * speed);
	uv.x = fract(uv.x - TIME * speed * slant);
	vec4 col = texture(TEXTURE, uv);
	
	// Fade smoothly at top (under cloud) and bottom
	float fade = smoothstep(0.0, 0.1, UV.y) * smoothstep(1.0, 0.85, UV.y);
	COLOR = col * COLOR;
	COLOR.a *= fade * density;
}
