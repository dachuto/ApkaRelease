#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D u_Texture_a;
uniform sampler2D u_Texture_b;

varying vec2 v_TexCoordinate;

void main() {
	vec4 a = texture2D(u_Texture_a, v_TexCoordinate);
	vec4 b = texture2D(u_Texture_b, v_TexCoordinate);

	gl_FragColor = vec4((a.xyz - b.xyz) * 0.5 + 0.5, 1.0);
}
