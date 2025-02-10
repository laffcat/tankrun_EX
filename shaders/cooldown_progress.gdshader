shader_type canvas_item;

uniform vec4 clr : source_color;
uniform float progress : hint_range(0.0, 1.0);

float gtz(float input) { return max(0, sign(input)); }
// returns 1 if input > 0, else 0

void fragment() {
	COLOR.rgb = mix(COLOR.rgb, clr.rgb, gtz(UV.y - progress));
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
