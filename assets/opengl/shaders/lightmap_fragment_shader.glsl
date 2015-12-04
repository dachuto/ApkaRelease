#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D u_DiffuseTexture;
uniform sampler2D u_LightmapTexture;

varying vec2 v_TexCoordinate;

void main() {
	gl_FragColor = texture2D(u_DiffuseTexture, v_TexCoordinate) * texture2D(u_LightmapTexture, v_TexCoordinate);
}
