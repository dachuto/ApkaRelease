#ifdef GLES2
precision mediump float;
#endif

uniform sampler2D u_Texture;
uniform float u_Time;

varying vec4 v_Color;
varying vec2 v_TexCoordinate;

#define M_PI 3.1415926535897932384626433832795

void main() {
	vec2 altered_position = v_TexCoordinate;
	altered_position.x += sin(4.0 * M_PI * (altered_position.y + u_Time)) * 0.1;

	gl_FragColor = texture2D(u_Texture, altered_position) * v_Color;
}

