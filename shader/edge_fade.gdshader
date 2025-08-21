shader_type canvas_item;

uniform bool radial_cut = true;
uniform vec2 screen_size = vec2(1920, 1080);
uniform float amount : hint_range(0.0, 1.0);
uniform float feather : hint_range(0.0, 1.0);

uniform float xoffset : hint_range(0.0, 0.5);
uniform float yoffset : hint_range(0.0, 0.5);




void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV;
	float screen_ratio = screen_size.x / screen_size.y;
	//uv += vec2(0.5);
	if (!radial_cut) {
		if (uv.x > 0.5){
			uv.x = 1.0 - uv.x;
		}
		if (uv.y > 0.5){
			uv.y = 1.0 - uv.y;
		}
		uv.x *= screen_ratio;
		
		float intensity = uv.x  - xoffset;
		
		if(intensity < amount){
			COLOR = vec4(0.0);
		} else if (intensity < amount + feather){
			COLOR *= (intensity - amount) / feather;
		}
		
		intensity = uv.y - yoffset;
		
		if(intensity < amount){
			COLOR = vec4(0.0);
		} else if (intensity < amount + feather){
			COLOR *= (intensity - amount) / feather;
		}
		
	} else {
		uv.x *= screen_ratio;
		float intensity = 1.0-distance(vec2(0.5 * screen_size.x / screen_size.y, 0.5), uv);
		
		if(intensity < amount){
			COLOR = vec4(0.0);
		} else if (intensity < amount + feather){
			COLOR *= (intensity - amount) / feather;
		}
		
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
