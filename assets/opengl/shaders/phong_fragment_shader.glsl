#ifdef GLES2
precision mediump float;
#endif

// Based on http://en.wikipedia.org/wiki/Blinn%E2%80%93Phong_shading_model

uniform vec3 u_LightPositionViewSpace;
uniform sampler2D u_Texture;

varying vec3 v_PositionViewSpace;
varying vec2 v_TexCoordinate;
varying vec3 v_Normal;

void main(void) {

	vec3 normal = normalize(v_Normal);
	vec3 light_direction = normalize(u_LightPositionViewSpace - v_PositionViewSpace);

	float lambertian = max(dot(normal, light_direction), 0.0);

//TODO: attenuation
//	float distance = length(light_position - v_Position);

	float specular = 0.0;
	if (lambertian > 0.0) {
		vec3 view_direction = normalize(-v_PositionViewSpace);

		vec3 reflect_direction = reflect(-light_direction, normal);
		float specular_angle = max(dot(reflect_direction, view_direction), 0.0);
		float shininess = 25.0;
		specular = pow(specular_angle, shininess);
	}

	float ambient = 0.3;
	float linear_brightness = ambient + lambertian + specular;
//	float linear_brightness = specular;

	vec4 surface_color = texture2D(u_Texture, v_TexCoordinate);
	vec3 specular_color = vec3(1.0);
	gl_FragColor = vec4(linear_brightness * surface_color.rgb, surface_color.a);
//	gl_FragColor = vec4(ambientColor + lambertian * diffuseColor + specular * specColor, 1.0);
}
