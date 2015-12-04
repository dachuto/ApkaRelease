#ifdef GL_ES
precision mediump float;
#endif

uniform float u_Threshold;
uniform float u_Width;

uniform sampler2D u_Texture;

varying vec4 v_Color;
varying vec2 v_TexCoordinate;

float contour(in float distance, in float smooth_width) {
	return smoothstep(u_Threshold - smooth_width, u_Threshold + smooth_width, distance);
}

float sample(in vec2 uv, float smooth_width) {
	return contour(texture2D(u_Texture, uv).r, smooth_width);
}

void main() {
	float distance = texture2D(u_Texture, v_TexCoordinate).r;
	
	float width = fwidth(distance) * 5.0f; // fwidth helps keep outlines a constant width irrespective of scaling
	
	//width += u_Width * 0.00000001;
	width = u_Width;

	float alpha = smoothstep(u_Threshold - width, u_Threshold + width, distance);
///////////// Supersampling
	float dscale = 0.354; // half of 1/sqrt2; you can play with this
	vec2 duv = dscale * (dFdx(v_TexCoordinate) + dFdy(v_TexCoordinate));
	vec4 box = vec4(v_TexCoordinate - duv, v_TexCoordinate + duv);

	float asum = sample( box.xy, width )
		+ sample( box.zw, width )
		+ sample( box.xw, width )
		+ sample( box.zy, width );

    // weighted average, with 4 extra points having 0.5 weight each,
    // so 1 + 0.5*4 = 3 is the divisor
    alpha = (alpha + 0.5 * asum) / 3.0;
/////////////////////////
	
	vec4 color = v_Color;
	color.a *= alpha;
	gl_FragColor = color;
}

