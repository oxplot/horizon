#version 330
layout(points) in;
layout(triangle_strip, max_vertices = 64) out;


in vec2 p0_to_geom[1];
in vec2 p1_to_geom[1];
in vec2 p2_to_geom[1];
in int color_to_geom[1];
in int color2_to_geom[1];
in int lod_to_geom[1];
smooth out vec3 color_to_fragment;
smooth out vec2 round_pos_to_fragment;
flat out float a0;
flat out float a1;
flat out float border_width;
flat out float line_width;


##ubo

vec4 t(vec2 p) {
    return vec4((screenmat*viewmat*vec3(p, 1)), 1);
}

vec2 p2r(float phi, float l) {
	return vec2(cos(phi), sin(phi))*l;
}

void main() {
	vec2 p0 = p0_to_geom[0];
	vec2 p1 = p1_to_geom[0];
	vec2 p2 = p2_to_geom[0];
	
	color_to_fragment = get_color(color_to_geom[0], color2_to_geom[0]);

    a0 = p1.x;
    a1 = p1.y;
	
    float width = p2.y;
	float r = p2.x;
    float r_max = r + width/2;
	float h = r_max*2;
	float z = 2;
	
	border_width = (min_line_width/scale)/r_max;
    line_width = max(width, min_line_width/scale) / r_max;
	
	for(int i = 0; i<3; i++) {
		float phi = PI*(2./3)*i;
		gl_Position = t(p0+p2r(phi, h));
		round_pos_to_fragment = p2r(phi,z);
		EmitVertex();
	}
	
	
	EndPrimitive();
	
}