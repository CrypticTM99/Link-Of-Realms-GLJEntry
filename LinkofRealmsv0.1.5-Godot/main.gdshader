shader_type sky;

uniform vec3 sky_color : source_color = vec3(0.01, 0.015, 0.04);
uniform vec3 star_color : source_color = vec3(1.0);

uniform float star_density = 180.0;
uniform float star_radius = 0.08;
uniform float twinkle_speed = 2.0;

uniform vec3 sky_rotation = vec3(0.0, 0.0, 0.0);


float hash21(vec2 p) {
	p = fract(p * vec2(234.34, 435.345));
	p += dot(p, p + 34.23);
	return fract(p.x * p.y);
}


vec2 hash22(vec2 p) {
	float n = hash21(p);

	return vec2(
		hash21(p + n),
		hash21(p + n + 17.3)
	);
}


mat3 rotate_y(float a) {
	float c = cos(a);
	float s = sin(a);

	return mat3(
		vec3(c, 0.0, -s),
		vec3(0.0, 1.0, 0.0),
		vec3(s, 0.0, c)
	);
}


void sky() {

	vec3 dir = normalize(EYEDIR);

	// Fixed sky orientation
	dir = rotate_y(sky_rotation.y) * dir;


	float u = atan(dir.x, dir.z) / TAU + 0.5;
	float v = asin(dir.y) / PI + 0.5;


	vec2 uv = vec2(u, v);


	vec2 grid_uv = uv * star_density;
	vec2 cell = floor(grid_uv);
	vec2 local = fract(grid_uv);


	vec2 star_pos = hash22(cell);

	float d = distance(local, star_pos);

	float mask = smoothstep(
		star_radius,
		star_radius * 0.25,
		d
	);


	float seed = hash21(cell);

	float twinkle = 0.7 + 0.3 *
		sin(TIME * twinkle_speed + seed * TAU);


	float star = mask * twinkle;


	COLOR = sky_color + star * star_color;
}