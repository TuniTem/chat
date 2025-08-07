shader_type canvas_item;

uniform float scale : hint_range(0.1, 5.0) = 1.0;
uniform float alpha : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec2 center = vec2(0.5);
    vec2 scaled_uv = (UV - center) / scale + center;
    COLOR = texture(TEXTURE, scaled_uv);
	COLOR.a *= alpha;
}
