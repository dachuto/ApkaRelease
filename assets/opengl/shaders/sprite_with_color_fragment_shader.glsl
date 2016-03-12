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

//vec4 MultiplyKeepingBlackAndWhite(in vec4 image, in vec4 mask) {
//	vec4 temp = 4.0 * mask;
//	vec4 a = 2.0 - temp;
//	vec4 b = temp - 1.0;
//	return clamp(a * image * image + b * image, 0.0, 1.0);
//}

void main() {
	gl_FragColor = texture2D(u_Texture, v_TexCoordinate) * v_Color;
//	gl_FragColor = MultiplyKeepingBlackAndWhite(texture2D(u_Texture, v_TexCoordinate), v_Color);
}

