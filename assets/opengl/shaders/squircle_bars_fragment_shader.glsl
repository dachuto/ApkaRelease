#ifdef GL_ES
precision mediump float;
#endif

uniform float u_Bars;
uniform float u_Time;

varying vec2 v_Coordinate;

#define M_PI 3.1415926535897932384626433832795

float SinToUnit(in float sine) {
	return (sine + 1.0) * 0.5;
}

vec4 ColorCycle(in float unit) {
	float x = mix(0.0, 2.0 * M_PI, unit);
	float r = 0.0;
	float g = mix(0.33, 1.0, SinToUnit(cos(x)));
	float b = mix(0.5, 1.0, SinToUnit(sin(x)));
	return vec4(r,g,b, 1.0);
}

float Plasma3(in vec2 position, in float t) {
	position *= M_PI;
	const float iterations = 3.0;
	const vec2 weight = vec2(0.3, 0.7);
	for(float i = 1.0; i < iterations; i++) {
		vec2 new_position = position;
		new_position.x += weight.x * sin(M_PI * (i * position.y + 2.0 * t));
		new_position.y += weight.y * cos(M_PI * (i * position.x + 2.0 * t));
		position = new_position;
  	}	

	return SinToUnit(sin(position.x + position.y));
}

const vec2 ORIGIN = vec2(0.5, 0.5);

void main( void ) {
	vec2 position = v_Coordinate;

	position.x = fract(position.x * u_Bars);
	position -= ORIGIN;
	
	float box = 1.0 - 16.0 * length(position * position * position * position);
	float plasma = Plasma3(v_Coordinate, u_Time);
	
	vec4 box_color = vec4(box, box, box, 1.0);
	
	gl_FragColor = ColorCycle(plasma) * box_color;
}
