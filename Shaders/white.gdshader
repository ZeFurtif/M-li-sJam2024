shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV;
	vec4 col = texture(TEXTURE, UV);
	COLOR = vec4(1,1,1,col.a);
}