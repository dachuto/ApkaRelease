uniform mat4 u_MVPMatrix;

attribute vec4 a_Position;
attribute vec2 a_TexCoordinate;

attribute vec4 a_OtherParams;

varying vec2 v_Coordinate;

varying vec4 v_OtherParams;

void main() {
	v_Coordinate = a_TexCoordinate;
	v_OtherParams = a_OtherParams;

	gl_Position = u_MVPMatrix * a_Position;
}
