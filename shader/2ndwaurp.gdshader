// Converted/modified from ShaderToy: https://www.shadertoy.com/view/ldBXDD
// Attach this shader to a ColorRect

shader_type canvas_item;

uniform float wave_count : hint_range(1.0, 200.0, 1.0) = 20.0;
uniform float speed : hint_range(0.0, 10.0, 0.1) = 3.0;
uniform float height : hint_range(0.0, 0.1, 0.001) = 0.003;
uniform float falloff : hint_range(0.0, 1.0) = 0.0;
uniform bool invert = false;
uniform sampler2D noise;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
float distFromCen(vec2 p) {
    // Get the screen size (aspect ratio correction)
    vec2 screen_size = vec2(1920, 1080);
    // Normalize the coordinates to the center
    vec2 normalized_coords = p - 0.5; // Move the coordinates to the center
    normalized_coords.y *= screen_size.y / screen_size.x; // Adjust x based on aspect ratio

    return length(normalized_coords) * 2.0;
}
vec2 rotate(vec2 p, float angle){
	return vec2(cos(angle)*p.x-sin(angle)*p.y, sin(angle)*p.x + cos(angle)*p.y);
	}
void fragment() {
	float distMod = pow(invert ? distFromCen(UV) : 0.5 - distFromCen(UV), 1.0 / falloff);
	
	vec2 cPos = -1.0 + 2.0 * UV / (1.0 / TEXTURE_PIXEL_SIZE);
	float cLength = length(cPos);
	vec2 uv = FRAGCOORD.xy / (1.0 / SCREEN_PIXEL_SIZE).xy + (cPos/cLength) * cos(cLength * wave_count + TIME * speed) * height * distMod;//* texture(noise, UV + vec2(cos(TIME * 0.3), sin(TIME* 0.3))).r
    uv = rotate(uv, height * distMod * sin(TIME* speed * 0.1) * 10.0);
	vec3 col = texture(SCREEN_TEXTURE,uv).xyz;
	uv = rotate(uv, height * distMod * sin(TIME* speed * 0.1) * 0.1);
	vec3 col2 = texture(SCREEN_TEXTURE,uv).xyz;
	COLOR = vec4(vec3(col.g, col2.rb),1.0);
}