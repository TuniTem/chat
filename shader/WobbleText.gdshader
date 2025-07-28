shader_type canvas_item;

uniform float time_factor = 3.0;
uniform vec2 amplitude = vec2(5.0,1.0);
uniform float pos_factor = 1.0;

void vertex() {
	// cos giving float between -1, 1
	VERTEX.x += step(cos(TIME * time_factor + VERTEX.x * pos_factor + VERTEX.y * pos_factor) + 1.0, 1.0) * amplitude.x;
	VERTEX.y += step(cos(TIME * time_factor + VERTEX.x * pos_factor + VERTEX.y * pos_factor) + 1.0, 1.0) * amplitude.y;
}