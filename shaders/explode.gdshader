shader_type canvas_item;
render_mode unshaded;

uniform float cutoff_percentage : hint_range(0.0, 1.0);

void fragment() {
    float diff_x = abs(UV.x - 0.5);
	float diff_y = abs(UV.y - 0.5);
	float diff_radius = sqrt(pow(diff_x, 2) + pow(diff_y, 2));
	float max_radius = sqrt(2) / 2.0;
	
	if(diff_radius < max_radius * cutoff_percentage){
		COLOR.a = 0.0;
	}
	
}
