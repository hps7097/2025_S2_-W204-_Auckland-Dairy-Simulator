shader_type canvas_item;

uniform float brightness : hint_range(0.0, 2.0) = 1.2;
uniform float saturation : hint_range(0.0, 2.0) = 1.1;

void fragment() {
    vec4 color = texture(TEXTURE, UV);

    // Convert to grayscale (average luminance)
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));

    // Increase saturation a little
    color.rgb = mix(vec3(gray), color.rgb, saturation);

    // Apply brightness multiplier
    color.rgb *= brightness;

    COLOR = color;
}
