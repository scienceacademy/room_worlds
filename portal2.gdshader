shader_type spatial;
render_mode blend_add, depth_draw_opaque, cull_disabled;

uniform vec4 base_color:source_color;
uniform vec2 near_far=vec2(0.1,100.0);
uniform sampler2D hex_tex:hint_default_black;
uniform float hexes_scale:hint_range(1,100);
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;

float linearize(float val) {
    val = 2.0 * val - 1.0;
    //val = 2.0 * near_far[0] * near_far[1] / (near_far[1] + near_far[0] - val * (near_far[1] - near_far[0]));
    return val;
}

float tri_wave(float t, float offset, float y_offset) {
    return clamp(abs(fract(offset + t) * 2.0 - 1.0) + y_offset, 0, 1);
}

void fragment() {
    float zdepth = linearize(textureLod(DEPTH_TEXTURE, SCREEN_UV, 0.0).r);
    //calculating real world pos
    vec4 w_pos = INV_VIEW_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, textureLod(DEPTH_TEXTURE, SCREEN_UV, 0.0).r * 2.0 - 1.0, 1.0);
    w_pos.xyz /= w_pos.w;
    float zpos = linearize(FRAGCOORD.z);
    float diff = zdepth - zpos;
    float intersect = 0.0;
    if (diff > 0.0) {
        intersect = 1.0 - smoothstep(0.0, (1.0/near_far[1])*10.0, diff);
    }

    float t = tri_wave(TIME * 0.5, -UV.y * 0.5, -0.75) * 8.0;
    
    float pole = (1.0 - UV.y-0.3) * 1.5;
    float rim = clamp(1.0 - abs(dot(NORMAL, VERTEX)*0.75), 0.0, 1.0);
    float glow = clamp(max(max(intersect, rim), pole), 0.0, 1.0);

    vec3 hexes = texture(hex_tex, UV*hexes_scale).rgb;
    hexes.r *= t;
    hexes.g *= clamp(rim, 0, 1) * (sin((TIME*2.0) + hexes.b * 4.0)+1.0);
    
    hexes = (hexes.r + hexes.g) * base_color.rgb * 2.0 ;
    vec3 glow_color = smoothstep(base_color.rgb, vec3(1), vec3(pow(glow, 8)));
    vec3 final_color = (base_color.rgb) + (glow_color.rgb * glow) + hexes;

    ALBEDO = final_color;
    ALPHA = base_color.a;
}