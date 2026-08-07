shader_type canvas_item;


uniform float scanline_strength : hint_range(0.0,1.0) = 0.12;
uniform float vignette_strength : hint_range(0.0,1.0) = 0.18;
uniform float flicker_strength : hint_range(0.0,0.1) = 0.02;

uniform float line_strength : hint_range(0.0,1.0) = 0.06;



void fragment()
{
	vec2 uv = UV;


	vec4 overlay = vec4(0.0);



	// CRT scanlines

	float scanlines = sin(uv.y * 900.0);

	overlay.rgb -= vec3(scanlines * scanline_strength);



	// Random old CRT flicker

	float flicker =
		sin(TIME * 0.0)
		* flicker_strength;


	overlay.rgb += flicker;



	// Broken horizontal tracking line

	float moving_line =
		smoothstep(
			0.015,
			0.0,
			abs(
				uv.y -
				(fract(TIME * 0.12))
			)
		);


	overlay.rgb += vec3(moving_line * line_strength);



	// Screen vignette

	vec2 center = uv - vec2(0.5);

	float vignette =
		length(center);


	overlay.rgb -=
		vec3(
			vignette *
			vignette_strength
		);



	// Keep it transparent

	overlay.a = 0.35;


	COLOR = overlay;
}