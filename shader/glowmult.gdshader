shader_type canvas_item;
render_mode blend_add;
uniform float mult = 1.0;

void fragment (){
	COLOR *= mult;
}