shader_type sky;

uniform sampler2D noise1texture: repeat_enable;

void sky() {
	// Called for every visible pixel in the sky background, as well as all pixels
	// in the radiance cubemap.
	vec4 noise_color = texture(noise1texture, SKY_COORDS);
	
	COLOR = noise_color.rgb;
}
