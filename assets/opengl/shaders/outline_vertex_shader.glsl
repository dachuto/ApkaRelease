uniform mat4 u_ProjectionViewModelMatrix;

attribute vec4 a_Position;
attribute vec3 a_Normal;

void main() {
	float outline_width = 0.1;
	gl_Position = u_ProjectionViewModelMatrix * (a_Position + (vec4(a_Normal, 0.0) * outline_width));
}
