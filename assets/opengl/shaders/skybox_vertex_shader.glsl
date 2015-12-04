uniform mat4 u_ProjectionViewModelMatrix;

attribute vec4 a_Position;

varying vec3 a_CubeCoordinate;

void main() {
	gl_Position = (u_ProjectionViewModelMatrix * a_Position).xyww;
	a_CubeCoordinate = a_Position.xyz;
}
