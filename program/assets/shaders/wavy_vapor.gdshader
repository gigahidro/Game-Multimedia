shader_type canvas_item;

uniform float wave_speed : hint_range(0.0, 15.0) = 4.5;
uniform float wave_freq : hint_range(0.0, 30.0) = 9.0;
uniform float wave_amplitude : hint_range(0.0, 0.2) = 0.08;

void fragment() {
	vec2 uv = UV;
	// S-curve waving motion traveling upward towards the arrow tip
	float tip_damp = smoothstep(0.0, 0.22, uv.y);
	float wave = sin(uv.y * wave_freq + TIME * wave_speed) * wave_amplitude * tip_damp;
	uv.x += wave;
	
	if (uv.x < 0.0 || uv.x > 1.0) {
		COLOR = vec4(0.0);
	} else {
		vec4 tex = texture(TEXTURE, uv);
		COLOR = tex * COLOR;
	}
}
