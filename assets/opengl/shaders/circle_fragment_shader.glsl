#ifdef GLES2
precision mediump float;
#endif

varying vec4 v_Color;
varying vec2 v_TexCoordinate;

void main(void) {
	vec2 center = vec2(0.5);
	float radius = 0.5;
	float is_inside = step(length(v_TexCoordinate - center), radius);

	gl_FragColor = v_Color * is_inside;
}
