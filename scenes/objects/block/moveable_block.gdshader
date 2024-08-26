shader_type spatial;
render_mode blend_mix, cull_front, unshaded;

uniform vec4 color : source_color = vec4(255,255,255,255);
uniform float size : hint_range(1.0, 1.5, 0.01) = 1.05;
uniform bool enable_shader = true;

void vertex() {
	VERTEX *= size;
}

void fragment() {
	ALBEDO = color.rgb;
	if(enable_shader){
		ALPHA = color.a;
	}
	else{
		ALPHA = 0.0;
	}
	
	
}
