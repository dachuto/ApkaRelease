#ifdef GLES2
precision mediump float;
#endif

uniform vec4 u_Color;

void main(void) {
	gl_FragColor = u_Color;
}
