#ifdef GL_ES
precision mediump float;
#endif

float SchlicksApproximation(in float cosine) {
//	const float R0 = 0.020408; // air -> water
	const float R0 = 0.05; // FAKE
	float temp = pow(1.0 - cosine, 5.0);
	return R0 + (1.0 - R0) * temp;
}

float FragmentDepthToEyeCoordinates(in float depth, in float near, in float far) {
	return 2.0 * far * near / (far + near - (far - near) * depth);
}

#define M_PI 3.1415926535897932384626433832795

float WaveHeight(in float Amplitude, in float Frequency, in float PhaseSpeed, in vec2 Direction, in vec2 xy, in float time) {
	return Amplitude * sin(dot(Direction, xy) * Frequency + time * PhaseSpeed);
}

vec2 WaveDerivatives(in float Amplitude, in float Frequency, in float PhaseSpeed, in vec2 Direction, in vec2 xy, in float time) {
	float common_factor = Amplitude * Frequency * cos(dot(Direction, xy) * Frequency + time * PhaseSpeed);
	return vec2(Direction.x * common_factor, Direction.y * common_factor);
}

vec3 Wrap(in float Amplitude, in float WaveLength, in float Speed, in vec2 Direction, in vec2 xy, in float time) {
	float frequency = 2.0 * M_PI / WaveLength;
	float phase_speed = frequency * Speed;
	return vec3(WaveDerivatives(Amplitude, frequency, phase_speed, Direction, xy, time), WaveHeight(Amplitude, frequency, phase_speed, Direction, xy, time));
}

uniform mat4 u_ViewModelMatrix;
uniform mat3 u_NormalMatrix;
uniform float u_Time;

uniform sampler2D u_ReflectionTexture;
uniform sampler2D u_RefractionTexture;
uniform sampler2D u_DepthTexture;
uniform sampler2D u_WaterColorTexture;

varying vec4 v_PositionObjectSpace;
varying vec4 v_PositionProjectionSpace;

void main() {
	vec3 wave = v_PositionObjectSpace.xyz;
	vec3 position_view_space = (u_ViewModelMatrix * v_PositionObjectSpace).xyz;

	vec3 normal_object_space = vec3(0.0, 0.0, 1.0);
	vec3 xyh;
	xyh = Wrap(0.5, 0.1, 0.025, vec2(1.0, 0.3), wave.xy, u_Time);
	normal_object_space.xy -= xyh.xy;
	wave.z += xyh.z;

	xyh = Wrap(0.25, 0.05, 0.025, vec2(1.0, 0.0), wave.xy, u_Time);
	normal_object_space.xy -= xyh.xy;
	wave.z += xyh.z;

	xyh = Wrap(0.1, 0.033, 0.01, vec2(1.0, -0.2), wave.xy, u_Time);
	normal_object_space.xy -= xyh.xy;
	wave.z += xyh.z;

	xyh = Wrap(0.05, 0.05, 0.005, vec2(1.0, 0.5), wave.xy, u_Time);
	normal_object_space.xy -= xyh.xy;
	wave.z += xyh.z;
	//TODO(piotr.daszkiewicz@gmail.com)[Jan 20, 2016]: BETTER PARAMS FOR WAVES

	normal_object_space = normalize(normal_object_space);
//////////////////////////////

	vec3 normal_view_space = normalize(u_NormalMatrix * normal_object_space);
	vec3 straight_up_normal_view_space = normalize(u_NormalMatrix[2]); // same as * vec3(0.0, 0.0, 1.0)

	//TODO(piotr.daszkiewicz@gmail.com)[Jan 20, 2016]: add specular highlights

	vec4 sampling_position = v_PositionProjectionSpace;
	const float DISTORTION_FACTOR = 2.5;
	sampling_position.xy += (normal_view_space.xz - straight_up_normal_view_space.xz) * DISTORTION_FACTOR;

	vec4 normalized_device_coordinates_without_distortion = (vec4(v_PositionProjectionSpace / v_PositionProjectionSpace.w) + 1.0) * 0.5;

	vec4 normalized_device_coordinates_distorted = (vec4(sampling_position / sampling_position.w) + 1.0) * 0.5;

	vec2 reflection_sample_coordinates = normalized_device_coordinates_distorted.xy;
	reflection_sample_coordinates.x = 1.0 - reflection_sample_coordinates.x; // reflection texture is rendered upside-down; flip x to get true mirror effect

	vec4 reflection_color = texture2D(u_ReflectionTexture, reflection_sample_coordinates);

	vec4 depth = texture2D(u_DepthTexture, normalized_device_coordinates_distorted.xy);
	float zNear = 1.0;
	float zFar = 1000.0;
	float fragment_depth_eye_coordinates = FragmentDepthToEyeCoordinates(gl_FragCoord.z, zNear, zFar);
	float refraction_depth_eye_coordinates = FragmentDepthToEyeCoordinates(depth.r, zNear, zFar);

	float water_thickness_eye_coordinates = abs(fragment_depth_eye_coordinates - refraction_depth_eye_coordinates);

	vec3 view_direction_view_space = normalize(-position_view_space);
	float cosine = max(dot(normalize(view_direction_view_space), normal_view_space), 0.0); // our surface is flat so it is possible to "see" part of it with negative angle

	float reflection_coefficient = SchlicksApproximation(cosine);

	float WATER_THICKNESS_COLOR_CHANGE_LENGTH = 30.0;
	float depth_scale = min(water_thickness_eye_coordinates / WATER_THICKNESS_COLOR_CHANGE_LENGTH, 1.0);

	vec4 refraction_color = texture2D(u_RefractionTexture, normalized_device_coordinates_distorted.xy);
	vec4 accumulated_water_color = texture2D(u_WaterColorTexture, vec2(depth_scale, 0.5));
	vec4 water_color = mix(refraction_color, accumulated_water_color, depth_scale);

	//TODO(piotr.daszkiewicz@gmail.com)[Jan 20, 2016]: probing foam texture
//	const float FOAM_END_HEIGHT_WORLD_SPACE = 1.0;
//	float foam = clamp(water_thickness_eye_coordinates / FOAM_END_HEIGHT_WORLD_SPACE, 0.0, 1.0);
//	water_color = mix(vec4(1.0), water_color, foam);

	gl_FragColor = mix(water_color, reflection_color, reflection_coefficient);
//	float prevent_uniform_removal_optimization = 0.000001 * (u_ViewModelMatrix[0][0] + u_NormalMatrix[0][0] + u_Time + texture2D(u_ReflectionTexture, vec2(0.0, 0.0)).r + texture2D(u_RefractionTexture, vec2(0.0, 0.0)).r + texture2D(u_DepthTexture, vec2(0.0, 0.0)).r + texture2D(u_WaterColorTexture, vec2(0.0, 0.0)).r);
//	gl_FragColor = vec4(vec3(view_direction_view_space), 1.0) + vec4(prevent_uniform_removal_optimization);
}
