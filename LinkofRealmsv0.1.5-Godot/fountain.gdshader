shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back;

uniform sampler2D water_texture : source_color;

uniform vec2 flow_direction = vec2(0.0, 1.0);
uniform float flow_speed = 0.25;

uniform vec3 water_tint : source_color = vec3(0.2, 0.6, 1.0);

uniform float texture_scale = 1.0;
uniform float transparency = 0.85;

void fragment()
{
	vec2 uv = UV * texture_scale;

	// Move the water texture over the mesh
	uv += flow_direction * TIME * flow_speed;

	vec4 water = texture(water_texture, uv);

	// Base color
	ALBEDO = water.rgb * water_tint;

	// Completely matte (no shine)
	METALLIC = 0.0;
	ROUGHNESS = 1.0;
	SPECULAR = 0.0;

	// No emission/glow
	EMISSION = vec3(0.0);

	// Transparency
	ALPHA = water.a * transparency;
}