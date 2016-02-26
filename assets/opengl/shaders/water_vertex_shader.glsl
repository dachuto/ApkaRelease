uniform mat4 u_ProjectionViewModelMatrix;

attribute vec4 a_Position;

varying vec4 v_PositionObjectSpace;
varying vec4 v_PositionProjectionSpace;

void main() {
	gl_Position = u_ProjectionViewModelMatrix * a_Position;

	v_PositionObjectSpace = a_Position;
	v_PositionProjectionSpace = gl_Position;
}
