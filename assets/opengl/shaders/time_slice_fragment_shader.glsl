#ifdef GLES2
precision mediump float;
#endif

#define M_PI 3.1415926535897932384626433832795

const vec2 ORIGIN = vec2(0.5, 0.5);

float AtanToUnit(in float arc_tan) {
	return arc_tan / (2.0 * M_PI) + 0.5;
}

uniform float u_Time;
uniform vec4 u_Color;

varying vec2 v_Coordinate;

void main( void ) {
	vec2 origin = v_Coordinate - ORIGIN;
	float time_unit = u_Time;

	vec4 is_inside = vec4(step(time_unit, AtanToUnit(atan(origin.x, origin.y))));

	gl_FragColor = is_inside * u_Color;
}
