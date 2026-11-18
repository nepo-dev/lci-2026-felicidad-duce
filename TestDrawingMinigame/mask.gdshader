shader_type canvas_item;

uniform sampler2D mask_texture;

void fragment() {
    vec4 mask = texture(mask_texture, UV);
    COLOR = vec4(COLOR.r, COLOR.g, COLOR.b, mask.a);

}