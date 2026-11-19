shader_type texture_blit;

render_mode blend_sub;

uniform sampler2D source_texture0 : hint_blit_source0;

void blit() {
    COLOR0 = texture(source_texture0, UV) * MODULATE;
}