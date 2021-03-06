attribute vec4 a_Color;
attribute vec4 a_Position;
attribute vec2 a_TexCoordinate;

varying vec4 v_Color;
varying vec2 v_TexCoordinate;

void main() {
	v_Color = a_Color;
	v_TexCoordinate = a_TexCoordinate;

	gl_Position = a_Position;
}