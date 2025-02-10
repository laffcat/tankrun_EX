shader_type canvas_item;

uniform sampler2D static: repeat_enable;
uniform float static_mult : hint_range(0.0, 1.0) = 1.0;
uniform float threshold : hint_range(-3.0, 2.0) = .5;

float gtz(float input) { return max(0, sign(input)); }
// returns 1 if input > 0, else 0

void fragment() {
	COLOR.a = gtz( (texture(static, SCREEN_UV * 10.0).r * static_mult + UV.x + threshold) * COLOR.a );
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
