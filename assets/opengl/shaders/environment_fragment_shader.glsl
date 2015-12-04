#ifdef GLES2
precision mediump float;
#endif

// Based on http://learnopengl.com/#!Advanced-OpenGL/Cubemaps

uniform samplerCube u_CubeTexture;
uniform vec3 u_CameraPosition;

varying vec3 v_PositionViewSpace;
varying vec2 v_TexCoordinate;
varying vec3 v_Normal;

void main(void) {
	vec3 I = normalize(v_PositionViewSpace - u_CameraPosition);
	vec3 R = reflect(I, normalize(v_Normal));
	R += vec3(0.000001 * v_TexCoordinate, 1.0); // IGNORE v_TexCoordinate

	gl_FragColor = textureCube(u_CubeTexture, R);
}
