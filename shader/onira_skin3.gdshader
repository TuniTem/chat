shader_type spatial;
render_mode cull_front, unshaded;

uniform vec3 color : source_color = vec3(0,0,0);
uniform float thickness;
uniform float offset;

group_uniforms displacement;
uniform float height_scale = 0.5;
uniform sampler2D displacement;
uniform float speed = 0.0;
varying vec2 tex_position;

void vertex() {
	tex_position = VERTEX.xy / 2.0 + 0.5;
	float height = texture(displacement, tex_position + TIME * speed / 10.0).x * height_scale;
	VERTEX += (height + offset) * NORMAL;
	VERTEX += thickness*NORMAL;
}

void fragment() {
	ALBEDO = color;
}