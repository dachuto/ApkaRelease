#ifdef GLES2
precision mediump float;
#endif

uniform sampler2D u_Texture;
uniform float u_Time;

varying vec2 v_TexCoordinate;

const int SAMPLES = 5;
const float MAX_SAMPLE_DISTANCE = 0.1;

void main() {
	float sampleDist = u_Time;
	const float sampleStrength = 2.0;

	vec2 uv = v_TexCoordinate;

	vec2 direction = 0.5 - uv;
	float distance_from_center = length(direction);
	direction = direction / distance_from_center;

	vec4 color = texture2D(u_Texture, uv);
	vec4 sum = color;

	float scale_max = float(SAMPLES - 1);
	scale_max *= scale_max;
	float probing_scale = MAX_SAMPLE_DISTANCE / scale_max;

	for (int i = 0; i < SAMPLES; ++i) {
		float sample_i = probing_scale * float(i * i);
		vec2 offset = direction * sample_i * sampleDist;
		sum += texture2D( u_Texture, uv + offset );
		//sum += texture2D( u_Texture, uv - offset );
	}

	//sum *= 1.0 / float(1 * SAMPLES + 1);
	sum *= 1.0 / float(SAMPLES + 1);
	float t = distance_from_center * sampleStrength;
	t = clamp(t, 0.0, 1.0);

	gl_FragColor = mix(color, sum, t);
}
