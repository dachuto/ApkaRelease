#ifdef GLES2
precision mediump float;
#endif

#define M_PI 3.1415926535897932384626433832795

float MapUnit(in float t, in float a, in float b) {
	float mapped = b - a;
	mapped *= t;
	mapped += a;
	return mapped;
}

float SinToUnit(in float sine) {
	return (sine + 1.0) * 0.5;
}

uniform float u_Time;

varying vec2 v_Coordinate;

vec4 WaveColor(in float position_x, in float position_y) {
	float margin = 0.2;
	float offset = 2.0 * M_PI * position_x;
	float ray_center = SinToUnit(sin(offset));
	ray_center = MapUnit(ray_center, margin, 1.0 - margin);

	float ray_power = distance(ray_center, position_y);
	ray_power = 1.0 - ray_power * (1.0 / margin);
	ray_power = clamp(ray_power, 0.0, 1.0);

	ray_power *= MapUnit(SinToUnit(cos(offset)), 0.25, 1.0);

	return vec4(ray_power, ray_power, ray_power, 1.0);
}

void main() {
	vec2 p = v_Coordinate;

	p.x += 10.0 * u_Time + 0.001;
	gl_FragColor = WaveColor(0.5 + p.x, p.y) + WaveColor(p.x, p.y);
}
