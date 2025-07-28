shader_type canvas_item;

uniform sampler2D mask_texture;
uniform vec2 mask_size;
uniform float threshold = 0.1;
uniform float mask_scale : hint_range(0.9, 1.1, 0.01) = 1.0;
uniform bool disable = false;

void fragment() {
	if(!disable){
	    vec2 uv = UV;

	    if (uv.x < 0.0 || uv.y < 0.0 || uv.x > 1.0 || uv.y > 1.0) {
	        discard;
	    }

	    vec4 mask_color = texture(mask_texture, uv * mask_scale);
	    if (mask_color.a < threshold) {
	        discard;
	    }
	}
}
