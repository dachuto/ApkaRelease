#ifdef GL_ES
precision mediump float;
#endif

uniform samplerCube u_CubeTexture;

varying vec3 a_CubeCoordinate;

void main() {
	gl_FragColor = textureCube(u_CubeTexture, a_CubeCoordinate);
}
