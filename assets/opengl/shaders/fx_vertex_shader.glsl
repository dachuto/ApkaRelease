uniform mat4 u_MVPMatrix;		// A constant representing the combined model/view/projection matrix.

attribute vec4 a_Position;
attribute vec2 a_TexCoordinate; // Per-vertex texture coordinate information we will pass in.

varying vec2 v_Coordinate;

void main() {
	v_Coordinate = a_TexCoordinate;

	gl_Position = u_MVPMatrix * a_Position;
}
