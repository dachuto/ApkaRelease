#ifdef GLES2
precision mediump float;
#endif

uniform sampler2D u_Texture;
uniform vec2 u_AberrationOffset;

varying vec2 v_TexCoordinate;

void main() {
	vec4 red_value = texture2D(u_Texture, v_TexCoordinate + u_AberrationOffset);
	vec4 green_value = texture2D(u_Texture, v_TexCoordinate);
	vec4 blue_value = texture2D(u_Texture, v_TexCoordinate - u_AberrationOffset);

	gl_FragColor = vec4(red_value.r, green_value.g, blue_value.b, 1.0);
}
