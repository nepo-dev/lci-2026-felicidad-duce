shader_type canvas_item;

uniform sampler2D mask_texture;

void fragment() {
    vec4 mask = texture(mask_texture, UV);
    COLOR = vec4(1.0, 1.0, 1.0, mask.a);

}