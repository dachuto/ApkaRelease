#ifdef GL_ES
precision mediump float;
#endif

varying vec2 v_Coordinate;

varying vec4 v_OtherParams;

#define M_PI 3.1415926535897932384626433832795

float MapUnit(float t, in float a, in float b) {
	float mapped = b - a;
	mapped *= t;
	mapped += a;
	return mapped;
}

float MapToUnit(float a, float b, float unit) {
	return (unit - a) / (b - a);
}

float IntervalIndicator(float a, float b, float x) {
	return step(a, x) - step(b, x);
}

float Sawtooth(float x, float teeth) {
	return fract(x * teeth) + max(0.0, MapToUnit(floor(teeth) / teeth, 1.0, x) * (ceil(teeth) - teeth));
}

float SquircleBox(vec2 position, float bars) {
	const vec2 ORIGIN = vec2(0.5, 0.5);
	position.x = Sawtooth(position.x, bars);
	position -= ORIGIN;
	position *= 2.0;
	position *= position;
	position *= position;
	return 1.0 - length(position);
}

float AtanToUnit(in float arc_tan) {
	return arc_tan / (2.0 * M_PI) + 0.5;
}

vec2 UVToCircle(vec2 uv) {
	vec2 center = vec2(0.5);
	uv -= center;
	float distance_rescaled = 2.0 * length(uv);
	return vec2(AtanToUnit(atan(uv.y, uv.x)), distance_rescaled);
}

void main(void) {
	vec2 uv = v_Coordinate;
	float inner_circle_radius = v_OtherParams.x;
	float bars = v_OtherParams.y;
	float hp_percent = v_OtherParams.z;
	float opacity = v_OtherParams.w;

	uv = UVToCircle(uv);
	uv.y = MapToUnit(inner_circle_radius, 1.0, uv.y);

	float box = SquircleBox(uv, bars);
	float transparent_ring = IntervalIndicator(0.0, 1.0, uv.y);

	gl_FragColor = vec4(box, box, box, transparent_ring * opacity) * step(uv.x, hp_percent);
}
