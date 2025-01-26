shader_type canvas_item;
const float darkening_factor = 0.3;
uniform float blur_amount : hint_range(0, 5);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec4 screen_color = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount);
    screen_color.rgb *= darkening_factor; 
    COLOR = screen_color;
}