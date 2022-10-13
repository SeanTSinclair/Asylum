shader_type canvas_item;

uniform vec4 stun_color: hint_color = vec4(1);
uniform float stun_amount: hint_range(0.0, 1.0) = 0;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	color.rgb = mix(color.rgb, stun_color.rgb, stun_amount);
	COLOR = color;
}