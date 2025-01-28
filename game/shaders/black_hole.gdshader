shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear;

uniform sampler2D curve;
uniform sampler2D curve2;
uniform float factor = 1.0;
void fragment() {
	vec2 vecToCenter = vec2(0.5, 0.5) - UV;
	float distToCenter = length(vecToCenter);
	float curveVec = texture(curve, vec2(distToCenter)).r;
	float curveVec2 = texture(curve2, vec2(distToCenter)).r;
	vec2 diff = normalize(vecToCenter) * 0.6 * curveVec;

	vec2 uv = SCREEN_UV - diff * factor;
	vec4 green_channel = texture(SCREEN_TEXTURE, uv);
	vec4 red_channel = texture(SCREEN_TEXTURE,
		vec2(uv.x + curveVec2 * 0.01 * factor, uv.y));
	vec4 blue_channel = texture(SCREEN_TEXTURE,
		vec2(uv.x, uv.y - curveVec2 * .03 * factor));

	COLOR = vec4(red_channel.r, green_channel.g, blue_channel.b, 1.0);
}