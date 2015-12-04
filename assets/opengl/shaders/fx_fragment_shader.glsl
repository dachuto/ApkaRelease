#ifdef GLES2
precision mediump float;
#endif

#define M_PI 3.1415926535897932384626433832795

const float CIRCULAR_STEP = 72.0;
const vec2 ORIGIN = vec2(0.5, 0.5);

const float RAY_COLOR_CYCLES_MIN = 1.0;
const float RAY_COLOR_CYCLES_MAX = 5.0;

const float COLOR_RANGE_MIN = 0.33;
const float COLOR_RANGE_MAX = 1.00;

float RandomUnit(in float unit) {
	const float A = 0.2;
	const float B = 0.3;
	const float C = 0.5;
	unit = 16.0 * M_PI * unit;
	unit = A * sin(1.0 / A * unit) + B * sin(1.0 / B * unit) + C * sin(1.0 / C * unit);
	unit = (1.0 + unit) * 0.5;
	return unit;
}

float MapUnit(in float t, in float a, in float b) {
	float mapped = b - a;
	mapped *= t;
	mapped += a;
	return mapped;
}

float SinToUnit(in float sine) {
	return (sine + 1.0) * 0.5;
}

float AtanToUnit(in float arc_tan) {
	return arc_tan / (2.0 * M_PI) + 0.5;
}

float CycleUnit(in float unit) {
	return sin(M_PI * unit);
}

float CycleUnitLinear(in float unit) {
	return abs(unit - 0.5) * 2.0;
}

float StepInterval(in float x, in float a, in float b, in float steps) {
	float step_length = (b - a) / steps;
	float step_number = (x - a) / step_length;
	step_number = ceil(step_number);
	return a + step_number * step_length;
}

float RadialStep(in vec2 position) {
	float color = AtanToUnit(atan(position.y, position.x));
	color = StepInterval(color, 0.0, 1.0, CIRCULAR_STEP);
	return color;
}

vec2 Gravity(in vec2 position, in float random_unit) {
	float angle = atan(position.y, position.x);
	angle = StepInterval(angle, 0.0, 2.0 * M_PI, CIRCULAR_STEP);
	float spread = 0.66 * M_PI;
	angle += MapUnit(random_unit, -spread, spread) * 0.5;
	return vec2(cos(angle), sin(angle));
}

float Ray(in vec2 position, in vec2 LINE, in float out_step, in float offset) {
	float color = dot(position, LINE);
	color += offset;
	color *= out_step;
	color = fract(color);
	color = CycleUnitLinear(color);
	return StepInterval(color, 0.0, 1.0, 8.0);;
}

vec4 ColorCycle(in float unit) {
	float x = mix(0.0, 2.0 * M_PI, unit);

	float r = SinToUnit(sin(x + 0.0));
	float g = SinToUnit(sin(x + 2.0));
	float b = SinToUnit(sin(x + 4.0));
	return vec4(r,g,b, 1.0);
}

uniform float u_Time;
uniform float u_ColorCycleUnit;

varying vec2 v_Coordinate;

void main( void ) {
	vec2 origin = v_Coordinate - ORIGIN;
	float time_unit = u_Time;

	float component1 = RadialStep(origin);

	component1 = RandomUnit(component1);

	//vec4 color1 = vec4(component1, component1, component1, 1.0);

	float out_step = ceil(MapUnit(component1, RAY_COLOR_CYCLES_MIN, RAY_COLOR_CYCLES_MAX));

	float ray_offset = time_unit + component1;

	vec2 gravity = Gravity(origin, component1);

	float component2 = Ray(origin, gravity, out_step, ray_offset);

	float final = MapUnit(component2, COLOR_RANGE_MIN, COLOR_RANGE_MAX);

	vec4 color2 = vec4(final, final, final, 1.0);

	gl_FragColor = color2 * ColorCycle(u_ColorCycleUnit);
}
