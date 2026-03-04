shader_type spatial;
group_uniforms displacement;
uniform vec3 intirior_color : source_color;
uniform float height_scale = 0.5;
uniform sampler2D displacement;
uniform float speed = 0.0;

varying vec2 tex_position;
void vertex() {
	tex_position = VERTEX.xy / 2.0 + 0.5;
	float height = texture(displacement, tex_position + TIME * speed / 10.0).x * height_scale;
	VERTEX += height * NORMAL;
}

void fragment() {
	ALBEDO = vec3(0.0);
	EMISSION = intirior_color;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
