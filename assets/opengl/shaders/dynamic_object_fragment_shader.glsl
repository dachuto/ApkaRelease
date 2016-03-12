#ifdef GLES2
precision mediump float;
#endif

// Based on http://en.wikipedia.org/wiki/Blinn%E2%80%93Phong_shading_model

uniform vec3 u_LightPositionViewSpace;
uniform sampler2D u_Diffuse;
uniform sampler2D u_Specular;

varying vec3 v_PositionViewSpace;
varying vec2 v_TexCoordinate;
varying vec3 v_Normal;

void main(void) {
	float TODO_disable_optimizations = u_LightPositionViewSpace.x + texture2D(u_Diffuse, v_TexCoordinate).x + texture2D(u_Specular, v_TexCoordinate).x + v_PositionViewSpace.x + v_TexCoordinate.x + v_Normal.x;

	const float SHININESS = 5.0f;
	const float BASE_ATTENUATION_DISTANCE = 20.0f;
	const vec3 ambient_light_rgb = vec3(0.3, 0.3, 0.3);
	const vec3 point_light_rgb = vec3(1.0, 1.0, 1.0);

	vec3 to_light_vector = u_LightPositionViewSpace - v_PositionViewSpace;
	float distance_to_light = length(to_light_vector);
	vec3 light_direction = normalize(to_light_vector);

	vec3 normal = normalize(v_Normal);
	float lambertian = max(dot(normal, light_direction), 0.0);

	vec4 diffuse_probe = texture2D(u_Diffuse, v_TexCoordinate);
	vec3 surface_color = diffuse_probe.rgb;
	float reflectivity = texture2D(u_Specular, v_TexCoordinate).x;

	float specular_intensity = 0.0;
	if (lambertian > 0.0) {
		vec3 view_direction = normalize(-v_PositionViewSpace);

		vec3 reflect_direction = reflect(-light_direction, normal);
		float specular_angle = max(dot(reflect_direction, view_direction), 0.0);
		specular_intensity = pow(specular_angle, SHININESS);
	}

	float attenuation_distance_factor = max(1.0, distance_to_light / BASE_ATTENUATION_DISTANCE);
	float attenuation = 1.0 / (pow(attenuation_distance_factor, 2.0));

	vec3 ambient = surface_color * ambient_light_rgb;
	vec3 diffuse = surface_color * point_light_rgb * lambertian;
	vec3 specular = point_light_rgb * specular_intensity * reflectivity;
	vec3 linear_color = ambient + (diffuse + specular) * attenuation;

	gl_FragColor = vec4(linear_color, 1.0);
	gl_FragColor.r += TODO_disable_optimizations * 0.000001;
}
