#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D u_Texture;

varying vec4 v_Color;
varying vec2 v_TexCoordinate;

//float SoftLight(float M, float I) {
//	float R = 1.0 - (1.0 - M) * (1.0 - I);
//	return ((1.0 - I) *  M + R) * I;
//}

//float Overlay(float M, float I) {
//	return I * (I + 2.0 * M * (1.0 - I));
//}


void main() {
	gl_FragColor = texture2D(u_Texture, v_TexCoordinate) * v_Color;
}

