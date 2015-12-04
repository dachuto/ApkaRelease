uniform mat4 u_MVPMatrix;		// A constant representing the combined model/view/projection matrix.

attribute vec4 a_Position;
attribute vec2 a_TexCoordinate;
attribute vec4 a_Color;

varying vec4 v_Color;
varying vec2 v_TexCoordinate;

void main() {
	v_Color = a_Color;
	v_TexCoordinate = a_TexCoordinate;

	gl_Position = u_MVPMatrix * a_Position;
}
