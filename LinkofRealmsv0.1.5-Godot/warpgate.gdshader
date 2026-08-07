shader_type spatial;

/*
    CRT Warp Gate Shader
    --------------------

    Created by CrypticTM

    A simple retro portal shader designed for a spinning warp gate surface.
    The goal is not to replace the texture, but to enhance it with:
    - subtle CRT scanlines
    - RGB glitch separation
    - slow texture movement
    - retro display distortion
    - texture-based glow

    The shader intentionally does NOT tint the portal.
    The original texture colors are preserved so the user can control
    the portal's appearance through the texture itself.

    Tips:
    - Use a noisy/swirl texture for the best portal effect.
    - Higher emission values create a stronger glow.
    - Keep glitch_strength low for a subtle CRT look.
    - This works best on a flat plane or circular portal mesh.
    - Pair with a rotating MeshInstance3D for a moving portal core.
*/


render_mode unshaded, blend_add, cull_back;


// The portal texture drives the entire look.
// Colors come directly from this texture.
uniform sampler2D portal_texture : source_color;


// Controls how quickly the texture appears to flow.
// Lower values create a slower, heavier portal movement.
uniform float flow_speed = 0.4;


// Amount of horizontal CRT distortion.
// Too high will make the portal look unstable.
uniform float glitch_strength = 0.015;


// Intensity of the horizontal CRT lines.
uniform float scanline_strength = 0.15;


// Controls how much the portal glows.
uniform float emission_strength = 2.0;



void fragment()
{
    vec2 uv = UV;


    // Move the texture slowly to give the portal some life.
    // This does not move the mesh itself.
    uv += vec2(
        TIME * 0.03,
        TIME * flow_speed
    );


    // Small horizontal signal glitches,
    // similar to an old CRT/VHS display.
    float glitch = sin(
        UV.y * 120.0 +
        TIME * 8.0
    );

    uv.x += glitch * glitch_strength;



    // Slight RGB separation to imitate
    // old display hardware errors.
    float rgb_offset = 0.008;

    float red = texture(
        portal_texture,
        uv + vec2(rgb_offset, 0.0)
    ).r;

    float green = texture(
        portal_texture,
        uv
    ).g;

    float blue = texture(
        portal_texture,
        uv - vec2(rgb_offset, 0.0)
    ).b;



    vec3 portal_color = vec3(
        red,
        green,
        blue
    );



    // CRT scanline effect.
    // Kept subtle so the texture remains readable.
    float scanlines = sin(
        UV.y * 700.0
    );

    scanlines = mix(
        1.0,
        scanlines,
        scanline_strength
    );


    portal_color *= scanlines;



    // Keep the original texture colors.
    // No forced color tinting happens here.
    ALBEDO = portal_color;


    // Glow is generated from whatever colors
    // already exist in the portal texture.
    EMISSION = portal_color * emission_strength;


    // Warp gates are usually solid glowing surfaces.
    ALPHA = 1.0;
}