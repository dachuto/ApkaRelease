uniform mat4 u_ProjectionViewModelMatrix;
uniform mat4 u_ViewModelMatrix;
uniform mat3 u_NormalMatrix;

attribute vec4 a_Position;
attribute vec2 a_TexCoordinate;
attribute vec3 a_Normal;

varying vec3 v_PositionViewSpace;
varying vec2 v_TexCoordinate;
varying vec3 v_Normal;

void main() {
	gl_Position = u_ProjectionViewModelMatrix * a_Position;

	v_PositionViewSpace = (u_ViewModelMatrix * a_Position).xyz;
	v_TexCoordinate = a_TexCoordinate;
	v_Normal = u_NormalMatrix * a_Normal;
}
